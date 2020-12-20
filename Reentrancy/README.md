
### REENTRANCY
* 意外觸發fallback()而發生類似遞迴重複呼叫其他函式的漏洞
   (在呼叫合約時若呼叫的函式沒有對到任何具名函式就會觸發fallback())
![](https://i.imgur.com/qFOjlJQ.png)


### 實作攻擊

* **IDMoney** :是一個類似公共錢包的合約，可以在裡面存款、提款及轉帳

* **require()** :檢查帳戶所有權及資產餘額

* **to.call.value(amount)()** :發送ether並處理完成後相應修改用戶資產資料

