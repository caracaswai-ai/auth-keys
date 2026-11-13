import discord
from discord.ext import commands, tasks
import json
import os
import time
import random
import string
from github import Github

intents = discord.Intents.default()
intents.message_content = True

bot = commands.Bot(command_prefix="!", intents=intents)

# ==========================================
# CONFIGURACIÓN DE GITHUB (REEMPLAZA CON TUS DATOS)
# ==========================================
GITHUB_TOKEN = "GITHUB_TOKEN"
GITHUB_REPO_NAME = "caracaswai-ai/auth-keys"

g = Github(GITHUB_TOKEN)
repo = g.get_repo(GITHUB_REPO_NAME)

KEYS_FILE_1 = "keys.json"
KEYS_FILE_2 = "keys2.json"

# CANALES DE LOGS
CANAL_LOGS_PRIVADAS = 1568600141210845316  # Nuevo canal para !crearkey y !crearkey2
CANAL_LOGS_PANEL1 = 1568513187521888363    # Canal viejo 1 para !publikey
CANAL_LOGS_PANEL2 = 1568734305721516032    # Canal viejo 2 para !publikey2

def load_keys(filename):
    if not os.path.exists(filename):
        return {}
    try:
        with open(filename, "r", encoding="utf-8") as f:
            return json.load(f)
    except Exception:
        return {}

def save_and_sync_keys(filename, data):
    # 1. Guardar localmente en VS Code
    with open(filename, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=4)
    
    # 2. Subir inmediatamente al archivo exacto en GitHub
    try:
        file_content = json.dumps(data, indent=4)
        contents = repo.get_contents(filename)
        repo.update_file(
            path=filename,
            message=f"Sync {filename} desde bot de Discord",
            content=file_content,
            sha=contents.sha
        )
        print(f"✅ [GITHUB] {filename} actualizado correctamente.")
    except Exception as e:
        print(f"❌ [ERROR GITHUB] No se pudo subir {filename}: {e}")

# ==========================================
# TAREA AUTOMÁTICA: Expira y sincroniza ambos archivos cada 60s
# ==========================================
@tasks.loop(seconds=60)
async def auto_expire_keys():
    current_time = time.time()
    
    for filename in [KEYS_FILE_1, KEYS_FILE_2]:
        data = load_keys(filename)
        updated_data = {}
        changes_made = False

        for k, v in data.items():
            expires_at = v.get("expiresAt", 0)
            if expires_at == 0 or expires_at > current_time:
                updated_data[k] = v
            else:
                changes_made = True
                print(f"⏰ Key expirada y eliminada de {filename}: {k}")

        if changes_made:
            save_and_sync_keys(filename, updated_data)

@bot.event
async def on_ready():
    print(f"¡Bot conectado como {bot.user}!")
    if not auto_expire_keys.is_running():
        auto_expire_keys.start()

# ==========================================
# INTERFAZ INTERACTIVA PARA EL PANEL (!viewkeys)
# ==========================================
class KeyManagementView(discord.ui.View):
    def __init__(self):
        super().__init__(timeout=180)
        self.update_components()

    def update_components(self):
        self.clear_items()
        keys1 = load_keys(KEYS_FILE_1)
        keys2 = load_keys(KEYS_FILE_2)
        current_time = time.time()
        options = []
        
        for k, data in keys1.items():
            if data.get("expiresAt", 0) == 0 or data.get("expiresAt", 0) > current_time:
                user = data.get('usedBy') or 'Público'
                label = f"[keys.json] {user} ({k[:10]}...)"
                options.append(discord.SelectOption(label=label[:100], value=f"P1:{k}", description=f"Eliminar de keys.json ({user})"))

        for k, data in keys2.items():
            if data.get("expiresAt", 0) == 0 or data.get("expiresAt", 0) > current_time:
                user = data.get('usedBy') or 'Público'
                label = f"[keys2.json] {user} ({k[:10]}...)"
                options.append(discord.SelectOption(label=label[:100], value=f"P2:{k}", description=f"Eliminar de keys2.json ({user})"))

        if options:
            select = discord.ui.Select(placeholder="🔍 Selecciona una Key para eliminarla...", min_values=1, max_values=1, options=options[:25])
            select.callback = self.select_callback
            self.add_item(select)
        else:
            no_keys_btn = discord.ui.Button(label="No hay keys activas para borrar", style=discord.ButtonStyle.secondary, disabled=True)
            self.add_item(no_keys_btn)

    async def select_callback(self, interaction: discord.Interaction):
        val = interaction.data["values"][0]
        panel_type, key_to_delete = val.split(":")

        if panel_type == "P1":
            keys = load_keys(KEYS_FILE_1)
            if key_to_delete in keys:
                del keys[key_to_delete]
                save_and_sync_keys(KEYS_FILE_1, keys)
                await interaction.response.send_message(f"🗑️ Key eliminada de `keys.json` y sincronizada en GitHub.", ephemeral=True)
            else:
                await interaction.response.send_message("❌ La key ya no existe.", ephemeral=True)
        elif panel_type == "P2":
            keys = load_keys(KEYS_FILE_2)
            if key_to_delete in keys:
                del keys[key_to_delete]
                save_and_sync_keys(KEYS_FILE_2, keys)
                await interaction.response.send_message(f"🗑️ Key eliminada de `keys2.json` y sincronizada en GitHub.", ephemeral=True)
            else:
                await interaction.response.send_message("❌ La key ya no existe.", ephemeral=True)

        self.update_components()
        await interaction.message.edit(view=self)

# ==========================================
# COMANDO: !crearkey (Privada -> keys.json | Log al canal nuevo)
# Uso: !crearkey [dias] [max_dispositivos] [usuario]
# ==========================================
@bot.command(name="crearkey")
async def crearkey(ctx, dias: int = 1, max_devices: int = 1, *, used_by: str = ""):
    try:
        await ctx.message.delete()
    except Exception:
        pass

    keys = load_keys(KEYS_FILE_1)
    key_code = "VIP-KEY-" + ''.join(random.choices(string.ascii_uppercase + string.digits, k=8))
    expires_at = int(time.time()) + (dias * 86400) if dias > 0 else 0
    
    keys[key_code] = {
        "durationDays": dias,
        "maxDevices": max_devices,
        "allowedHWIDs": [],
        "usedBy": used_by.strip(),
        "expiresAt": expires_at
    }
    save_and_sync_keys(KEYS_FILE_1, keys)
    
    embed = discord.Embed(title="🔑 Key Privada Creada (keys.json)", color=discord.Color.from_rgb(199, 28, 28))
    embed.add_field(name="Key", value=f"`{key_code}`", inline=False)
    embed.add_field(name="Días", value=str(dias), inline=True)
    embed.add_field(name="Dispositivos", value=str(max_devices), inline=True)
    embed.add_field(name="Asignado a", value=used_by if used_by else "Sin asignar", inline=False)
    embed.set_footer(text="Key 01 creada • 01Scripts Security")
    
    canal_logs = bot.get_channel(CANAL_LOGS_PRIVADAS)
    if canal_logs:
        await canal_logs.send(embed=embed)

# ==========================================
# COMANDO: !crearkey2 (Privada -> keys2.json | Log al canal nuevo)
# Uso: !crearkey2 [dias] [max_dispositivos] [usuario]
# ==========================================
@bot.command(name="crearkey2")
async def crearkey2(ctx, dias: int = 1, max_devices: int = 1, *, used_by: str = ""):
    try:
        await ctx.message.delete()
    except Exception:
        pass

    keys = load_keys(KEYS_FILE_2)
    key_code = "VIP-KEY-" + ''.join(random.choices(string.ascii_uppercase + string.digits, k=8))
    expires_at = int(time.time()) + (dias * 86400) if dias > 0 else 0
    
    keys[key_code] = {
        "durationDays": dias,
        "maxDevices": max_devices,
        "allowedHWIDs": [],
        "usedBy": used_by.strip(),
        "expiresAt": expires_at
    }
    save_and_sync_keys(KEYS_FILE_2, keys)
    
    embed = discord.Embed(title="🔑 Key Privada Creada (keys2.json)", color=discord.Color.from_rgb(199, 28, 28))
    embed.add_field(name="Key", value=f"`{key_code}`", inline=False)
    embed.add_field(name="Días", value=str(dias), inline=True)
    embed.add_field(name="Dispositivos", value=str(max_devices), inline=True)
    embed.add_field(name="Asignado a", value=used_by if used_by else "Sin asignar", inline=False)
    embed.set_footer(text="Key 02 creada • 01Scripts Security")
    
    canal_logs = bot.get_channel(CANAL_LOGS_PRIVADAS)
    if canal_logs:
        await canal_logs.send(embed=embed)

# ==========================================
# COMANDO: !publikey (Pública -> keys.json | Log al canal viejo 1)
# Uso: !publikey [dias] [limite_usuarios]
# ==========================================
@bot.command(name="publikey")
async def publikey(ctx, dias: int = 1, max_devices: int = 10):
    try:
        await ctx.message.delete()
    except Exception:
        pass

    keys = load_keys(KEYS_FILE_1)
    key_code = "FREE-KEY-" + ''.join(random.choices(string.ascii_uppercase + string.digits, k=8))
    expires_at = int(time.time()) + (dias * 86400) if dias > 0 else 0
    
    keys[key_code] = {
        "durationDays": dias,
        "maxDevices": max_devices,
        "allowedHWIDs": [],
        "usedBy": "Público",
        "expiresAt": expires_at
    }
    save_and_sync_keys(KEYS_FILE_1, keys)
    
    embed = discord.Embed(title="🌐 Key Pública Creada (keys.json)", color=discord.Color.from_rgb(199, 28, 28))
    embed.add_field(name="Key", value=f"`{key_code}`", inline=False)
    embed.add_field(name="Días", value=str(dias), inline=True)
    embed.add_field(name="Límite de Usuarios", value=str(max_devices), inline=True)
    embed.add_field(name="Acceso", value="Público", inline=False)
    embed.set_footer(text="Key 01 creada • 01Scripts Security")
    
    canal_logs = bot.get_channel(CANAL_LOGS_PANEL1)
    if canal_logs:
        await canal_logs.send(embed=embed)

# ==========================================
# COMANDO: !publikey2 (Pública -> keys2.json | Log al canal viejo 2)
# Uso: !publikey2 [dias] [limite_usuarios]
# ==========================================
@bot.command(name="publikey2")
async def publikey2(ctx, dias: int = 1, max_devices: int = 10):
    try:
        await ctx.message.delete()
    except Exception:
        pass

    keys = load_keys(KEYS_FILE_2)
    key_code = "FREE-KEY-" + ''.join(random.choices(string.ascii_uppercase + string.digits, k=8))
    expires_at = int(time.time()) + (dias * 86400) if dias > 0 else 0
    
    keys[key_code] = {
        "durationDays": dias,
        "maxDevices": max_devices,
        "allowedHWIDs": [],
        "usedBy": "Público",
        "expiresAt": expires_at
    }
    save_and_sync_keys(KEYS_FILE_2, keys)
    
    embed = discord.Embed(title="🌐 Key Pública Creada (keys2.json)", color=discord.Color.from_rgb(199, 28, 28))
    embed.add_field(name="Key", value=f"`{key_code}`", inline=False)
    embed.add_field(name="Días", value=str(dias), inline=True)
    embed.add_field(name="Límite de Usuarios", value=str(max_devices), inline=True)
    embed.add_field(name="Acceso", value="Público", inline=False)
    embed.set_footer(text="Key 02 creada • 01Scripts Security")
    
    canal_logs = bot.get_channel(CANAL_LOGS_PANEL2)
    if canal_logs:
        await canal_logs.send(embed=embed)

# ==========================================
# COMANDO: !borrarkey -> Borra de keys.json
# ==========================================
@bot.command(name="borrarkey")
async def borrarkey(ctx, *, target_user: str):
    try:
        await ctx.message.delete()
    except Exception:
        pass

    keys = load_keys(KEYS_FILE_1)
    borradas = 0
    target_clean = target_user.strip().lower()
    
    keys_a_borrar = [k for k, v in keys.items() if v.get("usedBy", "").strip().lower() == target_clean]
    for k in keys_a_borrar:
        del keys[k]
        borradas += 1
        
    save_and_sync_keys(KEYS_FILE_1, keys)
    await ctx.send(f"🗑️ Se eliminaron **{borradas}** key(s) de `{target_user}` en `keys.json`.", delete_after=10)

# ==========================================
# COMANDO: !borrarkey2 -> Borra de keys2.json
# ==========================================
@bot.command(name="borrarkey2")
async def borrarkey2(ctx, *, target_user: str):
    try:
        await ctx.message.delete()
    except Exception:
        pass

    keys = load_keys(KEYS_FILE_2)
    borradas = 0
    target_clean = target_user.strip().lower()
    
    keys_a_borrar = [k for k, v in keys.items() if v.get("usedBy", "").strip().lower() == target_clean]
    for k in keys_a_borrar:
        del keys[k]
        borradas += 1
        
    save_and_sync_keys(KEYS_FILE_2, keys)
    await ctx.send(f"🗑️ Se eliminaron **{borradas}** key(s) de `{target_user}` en `keys2.json`.", delete_after=10)

# ==========================================
# COMANDO: !viewkeys
# ==========================================
@bot.command(name="viewkeys")
async def viewkeys(ctx):
    try:
        await ctx.message.delete()
    except Exception:
        pass

    keys1 = load_keys(KEYS_FILE_1)
    keys2 = load_keys(KEYS_FILE_2)
    current_time = time.time()
    
    embed = discord.Embed(
        title="📊 01Scripts | Panel General de Keys Activas y Gestión", 
        description="────────────────────────────────────────\n🟢 **Estado del Sistema:** Sincronizado con GitHub\n⚡ **Control Directo:** Selecciona una key en el menú para borrarla.\n────────────────────────────────────────", 
        color=discord.Color.from_rgb(199, 28, 28)
    )
    
    texto_p1 = ""
    for k, data in keys1.items():
        if data.get("expiresAt", 0) == 0 or data.get("expiresAt", 0) > current_time:
            user = data.get('usedBy') or 'Público'
            texto_p1 += f"🔹 **Key:** `{k}`\n   ┗ 👤 **Usuario:** `{user}`\n"
    if texto_p1 == "":
        texto_p1 = "⚠️ No hay keys activas en keys.json."
    embed.add_field(name="📂 Panel 1 (keys.json)", value=texto_p1[:1024], inline=False)
    
    texto_p2 = ""
    for k, data in keys2.items():
        if data.get("expiresAt", 0) == 0 or data.get("expiresAt", 0) > current_time:
            user = data.get('usedBy') or 'Público'
            texto_p2 += f"🔹 **Key:** `{k}`\n   ┗ 👤 **Usuario:** `{user}`\n"
    if texto_p2 == "":
        texto_p2 = "⚠️ No hay keys activas en keys2.json."
    embed.add_field(name="📂 Panel 2 (keys2.json)", value=texto_p2[:1024], inline=False)
    
    embed.set_footer(text="© 2026 01Scripts Security • Sincronización GitHub en tiempo real")
    
    view = KeyManagementView()
    
    try:
        await ctx.send(embed=embed, view=view)
    except Exception as e:
        print(f"Error al enviar viewkeys: {e}")

bot.run("DISCORD_TOKEN")