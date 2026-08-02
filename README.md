# 🌌 LUAFIELD UI Library

![LUAFIELD Banner](https://via.placeholder.com/1200x350/0d0d12/825fff?text=LUAFIELD+UI+LIBRARY)

**LUAFIELD** adalah *UI Library Roblox* yang dirancang dengan desain modern, animasi transisi *smooth*, serta fitur fleksibel untuk membantu scripter membuat GUI Hub/Script dengan cepat dan estetik.

---

## ⚡ Fitur Utama

- 🎨 **Desain Modern & Clean** - Tampilan ala *dark mode* neon dengan efek visual yang rapi.
- 🌀 **Animasi Transisi Custom** - Memiliki fungsi intro & transisi layar yang fleksibel.
- 📱 **Support Mobile & PC** - Dilengkapi tombol melayang (*Floating Button*) drag & drop yang ramah pengguna Mobile/Touchscreen.
- 🚀 **Ringan & Cepat** - Optimasi event `RunService` dan `TweenService` tanpa bikin game *lag*.

---

## 🚀 Cara Penggunaan Singkat (Quick Start)

Untuk memanggil library **LUAFIELD** di dalam script kamu, gunakan fungsi `loadstring` berikut:

```lua
local LUAFIELD = loadstring(game:HttpGet("[https://raw.githubusercontent.com/USERNAME_KAMU/LUAFIELD/main/init.lua](https://raw.githubusercontent.com/USERNAME_KAMU/LUAFIELD/main/LUAFIELD.lua)"))()

-- Inisialisasi Window
local Window = LUAFIELD:Init({
    Name = "MY SCRIPT HUB",
    Transition = "custom",
    Blur = true
})

-- Buat Tab Baru
local MainTab = Window:CreateTab("Main Menu")
