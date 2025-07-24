## Remix 編譯器

remix 編譯器是將 sol 檔案的程式碼轉換成 bytecode 十六進制格式在部署到區塊鏈，然後 EVM 會去執行 bytecode 最後在 return 結果

Solidity 程式碼本身是給人看的，區塊鏈不認得。所以我們會用 Remix 編譯器把它轉成 EVM 能執行的 bytecode，也就是機器看得懂的十六進制格式。

這段 bytecode 就會被部署到區塊鏈上，變成一份智能合約。之後只要有人呼叫這份合約，EVM 就會去「照這段 bytecode 的邏輯」執行，該改資料的就改，該回傳結果的就回傳。

> bytecode ＝ 十六進制碼，如：0x608060405234801561001057600080fd5b50...
