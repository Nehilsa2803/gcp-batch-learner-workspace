
import pandas as pd
customers=pd.read_excel("C:\\Users\\Dell\\Downloads\\1322f651-7327-4e38-8b1e-2082aef076f0__globalmart.xlsx",sheet_name="customers")
print(customers)

orders=pd.read_excel("C:\\Users\\Dell\\Downloads\\1322f651-7327-4e38-8b1e-2082aef076f0__globalmart.xlsx",sheet_name="orders")
print(orders)


transactions=pd.read_excel("C:\\Users\\Dell\\Downloads\\1322f651-7327-4e38-8b1e-2082aef076f0__globalmart.xlsx",sheet_name="transactions")
print(transactions)

new_orders=pd.read_excel("C:\\Users\\Dell\\Downloads\\03c5bf18-6bef-4c85-83cf-e0bf1058e898_new_orders.xlsx")
print(new_orders)



orders["order_purchase_date"] = pd.to_datetime(
    orders["order_purchase_date"]
)

last_date = orders["order_purchase_date"].max()

six_month_orders = orders[
    orders["order_purchase_date"] >= (last_date - pd.DateOffset(months=6))
]

print(len(six_month_orders))


df=pd.merge(six_month_orders,transactions,on="order_id",how="inner")



customer_report = df.groupby("customer_id").agg(
    total_spending=("sales_amt", "sum"),
    order_count=("order_id", "count")
).reset_index()

print(customer_report)



customer_report = pd.merge(
    customer_report,
    customers[["customer_id","customer_name"]],
    on="customer_id",
    how="inner"
)


print(customer_report)




customer_report["tier"] = customer_report["total_spending"].apply(
    lambda x:
    "Silver" if x < 500 else
    "Gold" if x <= 2000 else
    "Platinum"
)

print(customer_report["tier"])



customer_report["discount_applicable"] = customer_report.apply(
    lambda x:
    2 if x["total_spending"] < 500 and x["order_count"] < 10 else
    4 if x["total_spending"] < 500 and x["order_count"] >= 10 else
    6 if x["total_spending"] <= 2000 and x["order_count"] < 10 else
    8 if x["total_spending"] <= 2000 and x["order_count"] >= 10 else
    10 if x["order_count"] < 10 else
    15,
    axis=1
)


print(customer_report["discount_applicable"] )

print(customer_report)



final_report=pd.merge(customer_report,new_orders,on="customer_id",how="right")
print(final_report)

final_report["discounted_price"]=final_report["Original Price"]*(1-final_report["discount_applicable"]/100)
print(final_report)



