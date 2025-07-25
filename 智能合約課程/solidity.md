## Remix 編譯器

remix 編譯器是將 sol 檔案的程式碼轉換成 bytecode 十六進制格式在部署到區塊鏈，然後 EVM 會去執行 bytecode 最後在 return 結果

Solidity 程式碼本身是給人看的，區塊鏈不認得。所以我們會用 Remix 編譯器把它轉成 EVM 能執行的 bytecode，也就是機器看得懂的十六進制格式。

這段 bytecode 就會被部署到區塊鏈上，變成一份智能合約。之後只要有人呼叫這份合約，EVM 就會去「照這段 bytecode 的邏輯」執行，該改資料的就改，該回傳結果的就回傳。

> bytecode ＝ 十六進制碼，如：0x608060405234801561001057600080fd5b50...

---

## 編譯器面板 (Solidity compiler)

![image](https://hackmd.io/_uploads/B18Duhkwxg.png)

### 🔧 基本設定區（上半部）

#### 1. `COMPILER` 下拉選單

👉 選擇 Solidity 編譯器版本。建議要跟你合約中的 `pragma solidity` 版本一致。例如你的合約寫：`pragma solidity ^0.8.0;`，那就選 `0.8.0` 或更新但不超過 `0.9.0` 的版本。

---

#### 2. `Include nightly builds`（不建議打勾）

👉 Nightly 是開發中、不穩定的版本，除非你要測試實驗功能，**不要開**。

---

#### 3. `Auto compile`（自動編譯）

👉 打勾後，每次你修改合約，Remix 會自動重新編譯。 📌 **開發階段可開啟，部署前記得手動編譯一次確認沒問題。**

---

#### 4. `Hide warnings`（隱藏警告）

👉 勾選後不顯示警告訊息。 📌 **建議不要打勾**，這樣才會看到潛在問題。

---

### 🔍 進階設定區（Advanced Configurations）

#### 5. `LANGUAGE`（語言）

👉 預設是 Solidity，正常不需改動。

---

#### 6. `EVM VERSION`（以太坊虛擬機版本）

👉 指定合約要用哪一版 EVM 編譯，目前預設是 **Prague（布拉格）**，即最新版本。

📌 通常用預設就好，除非你在開發針對舊版鏈（如 Ethereum Classic、L2）或要部署到特殊鏈。

---

#### 7. `Optimization`（優化）

- ✅ **打勾代表開啟優化功能**，可以讓編譯後的合約**更省 Gas**。
- `200` 是「優化次數」，一般設定 `200` 即可，適合大多數情況。

📌 若你要測試 gas 成本差異，也可以試著開/關優化比看看。

---

#### 8. `Use configuration file`

👉 你可以改用 `compiler_config.json` 來統一設定編譯規則。**一般不建議新手使用**，除非你用 Hardhat、Truffle 等框架配合。

---

### 🛠 編譯按鈕區（下方）

#### 9. `Compile <no file selected>`

👉 點它就會手動編譯目前打開的 `.sol` 合約檔案。

#### 10. `Compile and Run script`

👉 可以搭配 `.js` 腳本來自動編譯並執行腳本（例如部署合約）。但這功能在 Remix 中不常用，初學者可以跳過。

---

### ✅ 最實用建議（簡單記）：

| 設定項目      | 建議設定                   |
| ------------- | -------------------------- |
| Compiler 版本 | 跟 `pragma` 相符           |
| Auto Compile  | ✅ 開啟（開發中）          |
| Optimization  | ✅ 開啟，200               |
| EVM Version   | 預設 default（Prague）即可 |

---

## 部署與交易面板（DEPLOY & RUN TRANSACTIONS）

![image](https://hackmd.io/_uploads/r19WjnyPle.png)

這張圖是 Remix 的 **部署與交易面板**，是用來**部署合約**或**與已部署的合約互動**的地方。以下是功能拆解說明：

---

### 🔧 部署設定區（Deploy Settings）

#### 1. `ENVIRONMENT`（環境）

- `Remix VM (Prague)`：**Remix 內建的虛擬鏈**，不連網、測試用、重整就清空。
- 其他選項（像 Injected Provider、WalletConnect）是連到真實鏈或測試網，初學可先用 Remix VM。

📌 初學練習 → 用 Remix VM（預設就好） 📌 要部署到測試網 → 改成 Injected Provider（需接 Metamask）

---

#### 2. `ACCOUNT`

- 顯示當前使用的錢包帳戶（這裡是 0x5B3…，預設有 100 ETH，測試用）。
- 可點選下拉切換其他測試帳號。

---

#### 3. `+ Authorize Delegation`（目前可忽略）

- 用於授權代理執行合約交易（進階功能），你可以先跳過。

---

#### 4. `GAS LIMIT`

- `Estimated Gas`：讓 Remix 自動估算所需 gas（建議用這個）
- `Custom`：自己填 gas limit（單位是 gas，不是 ETH）

📌 沒特別需求就用預設 `Estimated Gas`

---

#### 5. `VALUE`

- 如果部署或呼叫合約需要 **附帶 ETH**，這裡可以填入。
- 預設是 `0 Wei`（Wei 是 ETH 的最小單位）

📌 合約如果有 `payable`，才需要填 value；否則留 `0` 就好。

---

### 📦 CONTRACT 區塊

#### 6. `No compiled contracts`

- 這裡會顯示你編譯後的合約清單。現在還沒編譯，所以顯示「No compiled contracts」。

📌 你要先去 **Solidity Compiler 面板點選編譯**，這裡才會出現可以部署的合約。

---

#### 7. `At Address`

- 如果你已知某合約地址，想直接跟它互動，可以點這裡輸入地址載入合約。

---

### 📄 下方區塊

#### 8. `Transactions recorded`

- 顯示你在 Remix VM 中執行的所有交易紀錄（部署、互動等）。

#### 9. `Deployed Contracts`

- 你部署的合約會出現在這裡，可以直接點選合約的方法進行呼叫。

---

### ✅ 快速流程建議：

1. 到 Solidity Compiler → 編譯你的 `.sol` 合約
2. 回到這個面板 → 在 CONTRACT 中選擇剛編譯好的合約
3. 點 `Deploy` → 合約就部署到 Remix VM
4. 部署後會出現在 `Deployed Contracts` 區域 → 可以操作合約的函式

---

## Smart Contract

```
// SPDX-License-Identifier: MIT
```

表示採用 MIT 開源授權，可自由複製、修改、商用，但需保留原始作者聲明。也是大多數都在使用的。

[SPDX License List](https://spdx.org/licenses/)

view : 能讀但不能改合約資料 pure : 既不讀也不改，只做數學或邏輯運算。

---

### Solidity 中的變數有六種主要儲存位置

| 區域         | 存放位置                    | 可否改動     | 存活時間       | Gas 成本      |
| ------------ | --------------------------- | ------------ | -------------- | ------------- |
| **storage**  | 區塊鏈永久儲存（狀態變數）  | 可改動       | 永久           | **最高**      |
| **memory**   | 臨時記憶體（函式執行期間）  | 可改動       | 函式結束即消失 | 中等          |
| **calldata** | 呼叫資料（外部輸入參數）    | **不可改動** | 函式執行期間   | 低            |
| **stack**    | EVM 運算棧（32 bytes/slot） | 可改動       | 指令執行期間   | **最低**      |
| **codes**    | 合約 bytecode（程式碼區）   | **不可改動** | 永久           | 無需 Gas 修改 |
| **logs**     | 事件記錄（鏈上 logs 區）    | **不可改動** | 永久（可查詢） | 寫入需 Gas    |

---

## Solidity 的 struct、array、mapping，在 JS/TS 中的類比。

### **1. Struct vs JS/TS Object**

| Solidity struct                   | JS/TS 類比                               |
| --------------------------------- | ---------------------------------------- |
| `struct` 定義一個自訂型別         | `interface` 或 `type` 定義物件結構       |
| 可用 `Person("Ken", 25)` 建立實例 | 可用 `{ name: "Ken", age: 25 }` 建立物件 |

**Solidity 範例：**

```solidity
struct Person {
    string name;
    uint age;
}

Person public p1 = Person("Ken", 25);
```

**TypeScript 類似寫法：**

```ts
type Person = {
  name: string
  age: number
}

const p1: Person = { name: 'Ken', age: 25 }
```

---

### **2. Array vs JS/TS Array**

| Solidity array      | JS/TS 類比 |
| ------------------- | ---------- |
| `uint[]` 是動態陣列 | `number[]` |
| `.push()` 新增元素  | `.push()`  |

**Solidity 範例：**

```solidity
uint[] public numbers;

function add(uint num) public {
    numbers.push(num);
}
```

**TypeScript 類似寫法：**

```ts
const numbers: number[] = []
function add(num: number) {
  numbers.push(num)
}
```

---

### **3. Mapping vs JS/TS Object/Map**

| Solidity mapping           | JS/TS 類比                                        |
| -------------------------- | ------------------------------------------------- |
| `mapping(address => uint)` | `Record<string, number>` 或 `Map<string, number>` |
| 使用 `balances[user]` 存取 | 使用 `balances[user]` 或 `balances.get(user)`     |

**Solidity 範例：**

```solidity
mapping(address => uint) public balances;

function setBalance(address user, uint amount) public {
    balances[user] = amount;
}
```

**TypeScript 類似寫法（用物件）：**

```ts
const balances: Record<string, number> = {}

function setBalance(user: string, amount: number) {
  balances[user] = amount
}
```

---

### **總結對比表**

| Solidity  | TypeScript            | 功能類比         |
| --------- | --------------------- | ---------------- |
| `struct`  | `type` 或 `interface` | 定義複雜資料結構 |
| `uint[]`  | `number[]`            | 有序列表         |
| `mapping` | `Record` 或 `Map`     | 鍵值對存取       |

---
