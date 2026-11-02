require("nvchad.mappings")

-- add yours here

local map = vim.keymap.set
local harpoon = require("harpoon")

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
-- Harpoon UI controls
map("n", "<leader>a", function()
    harpoon:list():add()
end, { desc = "Harpoon Add File" })
map("n", "<C-e>", function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon Toggle Menu" })

-- Quick jump to stored buffers (1-4)
map("n", "<leader>1", function()
    harpoon:list():select(1)
end, { desc = "Harpoon File 1" })
map("n", "<leader>2", function()
    harpoon:list():select(2)
end, { desc = "Harpoon File 2" })
map("n", "<leader>3", function()
    harpoon:list():select(3)
end, { desc = "Harpoon File 3" })
map("n", "<leader>4", function()
    harpoon:list():select(4)
end, { desc = "Harpoon File 4" })

-- Toggle between previous & next marked buffers
map("n", "<C-S-P>", function()
    harpoon:list():prev()
end, { desc = "Harpoon Prev File" })
map("n", "<C-S-N>", function()
    harpoon:list():next()
end, { desc = "Harpoon Next File" })
