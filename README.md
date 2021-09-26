# 2021_Summer
最佳化設計範例練習

以下內容可以同步於：https://hackmd.io/@Rchi666/BJEWc3YmY 參考

程式執行說明

Step I 取得 main.m 程式碼
![](https://i.imgur.com/KEpp9Ck.png)
請將同目錄中之 main.m 檔案，匯入 Matlab

Step II 設定特定參數
若針對本案例有需要調教之參數，例如材料參數(E,rho...)、node 位置等
詳細預設參數設定請見下表

Step III 執行
在經過設定後執行程式，結果如下圖所示
![](https://i.imgur.com/RY3VhLV.jpg)
本範例中，位移、應力與反作用力等參數與下方 Command Window 顯示
最佳化之結果 xans / exitflag 與 fval 均可以在右方 Workspace 顯示

本範例之材料參數設定表格
<img width="755" alt="image" src="https://user-images.githubusercontent.com/91275184/134802410-6035f578-e5f5-4f02-8a6c-5fe0fae2d51f.png">

本範例之邊界條件

1. 材料應力限制
    任意元件(Element)之應力值應小於材料能夠承受之最大應力值(sigma_y)
2. ΔS2<=0.02
    節點2位移值設定小於0.02m

最佳化目標

目標在符合邊界條件下，能夠計算出最低之材料使用(即最低之材料總質量)
最佳化目標函式：min(r1,r2) f(r1,r2) = SUM (mi*ri)
最佳化未知數範圍： 0.001<= r <= 0.5
