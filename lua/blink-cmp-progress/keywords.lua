local function get ()
   local kind = vim.lsp.protocol.CompletionItemKind

   return {
      {
         label = "define",
         kind = kind.Keyword,
         insertText = "define",
         textEdit = {
            newText = "define"
         }
      },
   }
end

return { get = get }
