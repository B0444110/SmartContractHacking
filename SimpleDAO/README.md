
### The DAO
1. 在攻擊前一周駭客提出一項專案，向The DAO平臺（母DAO專案）申請研究經費
     專案通過後，分出一個DAO子專案，並在一周後執行智慧合約分割功能splitDAO來建立新專案

2. 當母DAO執行withdrawRewardFor()要撥款給子DAO時，駭客透過自訂智慧合約的功能
    再次呼叫splitDAO功能，趕在扣款指令還未進行之前，再次執行專案建立功能進行再次撥款

![](https://i.imgur.com/myQqAup.png)

3. 因扣款完成前ether餘額仍是正值，在母DAO來不及更新平衡帳目前
   這項新建專案和撥款的動作可以不斷地重複執行

4. 透過遞迴的攻擊駭客讓母DAO不斷撥款，最後一共盜領了約370萬個乙太幣
   以當時乙太幣市價每個約20美元來計算，遭竊了價值約7200萬美元的乙太幣
![](https://i.imgur.com/dqivTlK.png)
5. 正常情況下The DAO的資產被分離之後就會被銷毀
 但駭客在調用結束前把盜來的The DAO資產轉移到了其他帳戶避免被銷毀

6. 駭客組合兩個漏洞進行攻擊，先觸發fallback()再利用遞迴調用清空DAO資產

7. 乙太坊採用硬分岔回復到駭客攻擊前，編號1,920,000的區塊重新開始計算


### 實作攻擊

* **SimpleDAO** :可以捐贈乙太幣給合約，也可以從合約中提款

* **Mallory2** :傳遞SimpleDAO的地址，會調用其fallback()
                        Mallory2中的fallback()會回叫withdraw來提取其他帳戶存入的存款

* **attack()** :可以以1 ether對 SimpleDAO 發動攻擊

* **getJackpot()** :用來清空SimpleDAO裡的存款

* **performAttack()** :用來查看是否已發動攻擊(true:還沒攻擊, false:已經攻擊)
