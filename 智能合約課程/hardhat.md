[Hardhat document](https://hardhat.org/hardhat-runner/docs/getting-started)

```
npx hardhat init
```

```
npx hardhat compile
```

### 腳本部署

本地

```
npx hardhat run script/FundMeFactory.js
```

鏈上

```
npx hardhat run script/FundMeFactory.js --network sepolia
```

## 環境配置

dotenv 可以讓你的 Node.js 專案自動讀取 .env 檔案，把裡面的環境變數（像是 RPC URL、私鑰等）載入到 process.env，讓程式可以安全地取得這些敏感資訊。

```
npm install dotenv
```

hardhat.config.js

```javascript
require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config(); // 添加這行讀取 .env 變數

/** @type import('hardhat/config').HardhatUserConfig */

// url 只能放 EVM 相容鏈的 RPC 端點，例如：
// Ethereum 主網或測試網（如 Sepolia、Goerli）
// Polygon、BSC、Arbitrum、Optimism 等 EVM 相容鏈
// 這些 RPC 端點通常來自 Infura、Alchemy、Chainstack 或官方節點
// 不能放 Solana、Aptos、Sui 等非 EVM 鏈的 RPC。

module.exports = {
  solidity: "0.8.28",
  networks: {
    sepolia: {
      url: process.env.SEPOLIA_RPC_URL,
      accounts: [process.env.PRIVATE_KEY],
    },
  },
};
```

.env

```
SEPOLIA_RPC_URL = https://eth-sepolia.g.alchemy.com/v2/fwpVW9jKErMUvEZ17coHO
PRIVATE_KEY = c5c11acd44e408b4d5b95b84beb9f0a9652d549a7b06eb90afe0c1c004524bed
```

## env-enc

[官方文件](https://github.com/smartcontractkit/env-enc)

**結論**：`.env-enc` **不是開發必備的標準檔案**，它是用來 **加密 .env 檔案的工具或產物**，並不是所有專案都會用到。

---

### 拆解說明

1. **什麼是 `.env-enc`？**
   - `.env` 存放環境變數（例如 API Key、私鑰）。
   - `.env-enc` 是經過 **加密** 後的 `.env`，常搭配一些工具（如 [dotenv-vault](https://www.dotenv.org/)、`env-enc` CLI）來防止敏感資訊直接暴露在原始碼中。

2. **平常開發會用嗎？**
   - 大部分前後端專案只需要 `.env`，不會用 `.env-enc`。
   - `.env-enc` 多出現在 **團隊專案、CI/CD、部署安全需求** 時才需要。

3. **什麼時候會用到？**
   - 當專案裡有敏感金鑰（如 Web3 私鑰、API Token），又需要上傳 `.env` 到 git 或共享時，才會先加密成 `.env-enc`。

---

### 比喻

`.env` 像是明文的鑰匙清單，`.env-enc` 就像用鎖頭鎖住的鑰匙盒；
平常本地開發不需要鎖，但團隊協作或上線時才會用。

---

#### 設定密碼

```
npx env-enc set-pw
```

![image](https://hackmd.io/_uploads/BJfcVY4Dex.png)

設定你的密碼 (k0910948659)

---

接下來就是把環境變數用加密的方式寫到 config 檔裡面

```
npx env-enc set
```

![image](https://hackmd.io/_uploads/r1omBKNvxg.png)

提供變數名稱，以我的 .env 檔案為例，SEPOLIA_RPC_URL 跟 PRIVATE_KEY，輸入完後會要再輸入 value，如果都設定完了就 enter 退出

```
// .env

SEPOLIA_RPC_URL = https://eth-sepolia.g.alchemy.com/v2/fwpVW9jKErMUvEZ17coHO
PRIVATE_KEY = c5c11acd44e408b4d5b95b84beb9f0a9652d549a7b06eb90afe0c1c004524bed
```

結果會多一個 .env.enc 檔案

```
// .env.enc

SEPOLIA_RPC_URL: ENCRYPTED|LIoM4lwZnNYp130VdvpXy/BeINRygsNV8a57W1sA7patTMN1y8VCHqERqLJmaCeK0eQoNBc21tBWSkI+yItPbLgzOJVU4Paq/RqwMaldcpY2wX97Z5ss6SFkrMIxno6LkDWzo/yPwAe/Rw==
PRIVATE_KEY: ENCRYPTED|zQQ70P4wpbEw+Ol4BG5JpMVPLpNh5IEIiI7zN35M27hu9M161LFV1PMnkOiV9VtgZkKUM8JUJM6dBsjoTcA23MYkxZUY3PwY7bNK2rQPBtpTfOkQkzUCutKN8OpoTtMZHG/Beoi5GhvgC1RkD0FMLQ==
```

最後在 config 檔案把 dotenv 改成 @chainlink/env-enc

```
// require("dotenv").config();
require("@chainlink/env-enc").config();
```

## hardhat-verify

**結論：**
`npx hardhat verify` 是用來在 Etherscan（或其他區塊鏈瀏覽器）上驗證合約原始碼，讓外界可以看到你的智能合約程式碼與編譯結果是否一致。

---

### 1. **定義**

- `hardhat verify`：Hardhat 插件 `@nomicfoundation/hardhat-verify` 的指令，用於提交你的合約原始碼與編譯資訊到 Etherscan API。
- `--network mainnet`：指定要驗證的網路（此例為 Ethereum 主網）。
- `DEPLOYED_CONTRACT_ADDRESS`：已部署合約的地址。
- `"Constructor argument 1"`：部署時合約建構函數（constructor）所傳入的參數，Etherscan 需要用它來驗證 bytecode。

依照上述定義修改指令

```
npx hardhat verify --network sepolia 0x0535f166E32877Aacd79cdB49345A3c6e40F73CB "10"
```

---

### 2. **拆解**

1. 你先在主網部署了一個合約，Etherscan 只會看到已編譯的 bytecode。
2. `hardhat verify` 會將你的源碼、編譯器版本、編譯設定和 constructor 參數送給 Etherscan。
3. Etherscan 會重新編譯你的原始碼，並檢查是否與區塊鏈上的 bytecode 一致。
4. 驗證通過後，Etherscan 頁面就會顯示你的 Solidity 原始碼、ABI 和讀寫介面。

---

### 3. **比喻**

想像你開了一家餐廳（部署了合約），顧客（使用者）只能看到你做好的菜（bytecode）。
`hardhat verify` 就像把菜譜（原始碼）交給美食評審（Etherscan），證明菜確實是按這份菜譜做的，顧客也能檢視菜譜。

---

### 4. **功能 / 用途 / 場景**

- **功能：** 將智能合約源碼與鏈上 bytecode 進行驗證。
- **做什麼用：** 提供公開透明度，讓開發者和用戶可以檢視並互動合約。
- **什麼時候用：** 部署合約後，想讓 Etherscan 顯示你的合約程式碼與可調用函數時必須使用。

---

但是沒有 API token 就不能在 sepolia 上面去 verify，如下圖錯誤提示
![image](https://hackmd.io/_uploads/rkaWTFVweg.png)

所以要去 [etherscan.io](https://etherscan.io/apidashboard) 申請
![image](https://hackmd.io/_uploads/r13rTYNwxe.png)

![image](https://hackmd.io/_uploads/S1YYG9Nvxl.png)
![image](https://hackmd.io/_uploads/H1XpfcVDlg.png)

但是這樣做太麻煩了，為了提高效率

```javascript
await hre.run("verify:verify", {
  address: await FundMe.getAddress(),
  constructorArguments: [10],
});
```

**結論：**
`await hre.run("verify:verify", {...})` 是在 Hardhat 腳本內呼叫 `hardhat-verify` 插件，將合約的地址與建構參數傳給 Etherscan 進行驗證。

---

### 1. **定義**

- `hre.run("verify:verify")`：執行 Hardhat 的 `verify` 任務，相當於在命令列執行 `npx hardhat verify`。
- `address: FundMe.getAddress()`：指定要驗證的合約地址。
- `constructorArguments: [10]`：傳入合約部署時使用的 constructor 參數。

---

### 2. **拆解**

1. `hre` 是 Hardhat Runtime Environment，允許你在腳本內直接調用任務。
2. `verify:verify` 是 `@nomicfoundation/hardhat-verify` 插件提供的任務名稱。
3. `FundMe.getAddress()` 會返回部署後 `FundMe` 合約的鏈上地址。
4. `constructorArguments` 必須與部署時的 constructor 參數完全一致，否則 Etherscan 驗證會失敗。

---

### 3. **功能 / 用途 / 場景**

- **功能：** 直接在部署腳本中進行 Etherscan 驗證，無需手動命令列。
- **做什麼用：** 方便自動化流程（例如部署完合約後自動執行驗證）。
- **什麼時候用：** 常用於部署腳本中 (`deploy.js` / `deploy.ts`)，一鍵完成部署 + 驗證。

---
