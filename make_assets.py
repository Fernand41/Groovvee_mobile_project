# make_assets.py
from PIL import Image, ImageOps

SRC = "assets/logo/logo_small_black.png"   # fichier d'origine, jamais modifié

# --- Réglages : ratio = taille du logo / taille du canevas ---
ADAPTIVE_RATIO = 0.62   # icône Android (max conseillé ~0.66)
SPLASH12_RATIO = 0.48   # splash Android 12+ (max conseillé ~0.50)
ICON_RATIO = 0.70       # icône classique / iOS
SPLASH_NATIVE_WIDTH = 300  # splash natif iOS / Android <= 11, en px

LOGO_COLOR = (34, 34, 34)  # le noir/gris foncé de ton logo


def load_logo():
    """Retire le fond blanc, recadre sur le logo, renvoie un PNG transparent."""
    img = Image.open(SRC).convert("RGBA")

    # On pose l'image sur du blanc, puis on convertit en niveaux de gris
    white = Image.new("RGBA", img.size, (255, 255, 255, 255))
    gray = Image.alpha_composite(white, img).convert("L")

    # Plus un pixel est foncé, plus il est opaque (le blanc devient transparent)
    alpha = ImageOps.invert(gray)

    # Zone réellement occupée par le logo
    bbox = alpha.point(lambda p: 255 if p > 20 else 0).getbbox()

    logo = Image.new("RGBA", img.size, LOGO_COLOR + (0,))
    logo.putalpha(alpha)
    return logo.crop(bbox)


def make_canvas(out, canvas, ratio, bg=(0, 0, 0, 0)):
    logo = load_logo()
    target = int(canvas * ratio)
    logo.thumbnail((target, target), Image.LANCZOS)  # garde les proportions
    # thumbnail() ne fait que réduire : on agrandit si le logo est plus petit
    if max(logo.size) < target:
        scale = target / max(logo.size)
        logo = logo.resize(
            (int(logo.width * scale), int(logo.height * scale)), Image.LANCZOS
        )
    img = Image.new("RGBA", (canvas, canvas), bg)
    img.paste(logo, ((canvas - logo.width) // 2, (canvas - logo.height) // 2), logo)
    img.save(out)
    print(f"OK -> {out} (logo {logo.width}x{logo.height})")


# Icône adaptative Android : fond transparent
make_canvas("assets/icon/app_icon_foreground.png", 1024, ADAPTIVE_RATIO)

# Splash Android 12+ : logo dans le cercle visible
make_canvas("assets/splash/logo_android12.png", 1152, SPLASH12_RATIO)

# Icône classique + iOS : fond blanc plein
make_canvas("assets/icon/app_icon.png", 1024, ICON_RATIO, bg=(255, 255, 255, 255))

# Logo du splash natif (iOS / Android <= 11)
logo = load_logo()
h = int(logo.height * SPLASH_NATIVE_WIDTH / logo.width)
logo.resize((SPLASH_NATIVE_WIDTH, h), Image.LANCZOS).save("assets/splash/logo.png")
print("OK -> assets/splash/logo.png")