# `🛠 WIP` conquest-ui

| Included Aftman tools |
|---|
| [Rojo](https://github.com/rojo-rbx/rojo) |
| [Wally](https://github.com/UpliftGames/wally) |
| [wally-package-types](https://github.com/johnnymorganz/wally-package-types) |
| [Stylua](https://github.com/johnnymorganz/stylua) |

| Included Wally packages |
|---|
| [Fusion](https://github.com/dphfox/Fusion) (UI Library) |

| Optional, but RECOMMENDED |
|---|
| [Hoarcekat](https://github.com/Kampfkarren/hoarcekat) |

## Getting Started
### **⚠️ Make sure you have [Aftman](https://github.com/LPGhatguy/aftman) installed**

Install Aftman tools:

```bash
aftman install
```

Install Wally packages:

```bash
wally install
```

Follow [this guide](https://github.com/JohnnyMorganz/wally-package-types?tab=readme-ov-file#wally-package-types-fixer) to generate exported types of Wally packages for type-checking.

Follow [this guide](https://rojo.space/docs/v7/getting-started/installation/#installing-the-plugin) to install Rojo Roblox Studio plugin if you don't have it already.

Build the place from scratch:

```bash
rojo build -o "conquest-ui.rbxlx"
```

Next, open `conquest-ui.rbxlx` in Roblox Studio and start the Rojo server:

```bash
rojo serve
```

For more help, check out [the Rojo documentation](https://rojo.space/docs).

## Developing

**Please write UI components as [Hoarcekat stories](https://github.com/Kampfkarren/hoarcekat).**
Example:
```luau
-- src/client/ui/<component name>.story.luau

local Fusion = require(game.ReplicatedStorage.Packages.Fusion)
local New = Fusion.New
-- ...

type <component name>Props = {
  -- ...
}

return function(target, props: <component name>Props)
  local ui = New "Frame" {
    Parent = target,
    -- ...
  }

  -- I'm unsure if you need to return a destructor
  return function()
    ui:Destroy()
  end
end
```
