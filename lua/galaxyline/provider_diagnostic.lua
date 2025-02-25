local vim,lsp,api = vim,vim.lsp,vim.api
local M = {}

-- coc diagnostic
local function get_coc_diagnostic(diag_type)
  local has_info,info = pcall(vim.fn.nvim_buf_get_var,0,'coc_diagnostic_info')
  if not has_info then return end
  if info[diag_type] > 0 then
    return  info[diag_type]
  end
  return ''
end

-- nvim-lspconfig
-- see https://github.com/neovim/nvim-lspconfig
local function get_nvim_lsp_diagnostic(diag_type)
  if next(lsp.buf_get_clients(0)) == nil then return '' end
  local active_clients = lsp.get_active_clients()

  if active_clients then
    local count = 0

    for _, client in ipairs(active_clients) do
       count = count + lsp.diagnostic.get_count(api.nvim_get_current_buf(),diag_type,client.id)
    end

    if count ~= 0 then return count end
  end
end

function M.get_diagnostic_error()
  if vim.fn.exists('*coc#rpc#start_server') == 1 then
    return get_coc_diagnostic('error')
  elseif not vim.tbl_isempty(lsp.buf_get_clients(0)) then
    return get_nvim_lsp_diagnostic('Error')
  end
  return ''
end

function M.get_diagnostic_warn()
  if vim.fn.exists('*coc#rpc#start_server') == 1 then
    return get_coc_diagnostic('warning')
  elseif not vim.tbl_isempty(lsp.buf_get_clients(0)) then
    return get_nvim_lsp_diagnostic('Warning')
  end
  return ''
end

function M.get_diagnostic_hint()
  if vim.fn.exists('*coc#rpc#start_server') == 1 then
    return get_coc_diagnostic('hint')
  elseif not vim.tbl_isempty(lsp.buf_get_clients(0)) then
    return get_nvim_lsp_diagnostic('Hint')
  end
  return ''
end

function M.get_diagnostic_info()
  if vim.fn.exists('*coc#rpc#start_server') == 1 then
    return get_coc_diagnostic('information')
  elseif not vim.tbl_isempty(lsp.buf_get_clients(0)) then
    return get_nvim_lsp_diagnostic('Information')
  end
  return ''
end

return M
