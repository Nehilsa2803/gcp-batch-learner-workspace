select full_name,age
from customers
where segment="Premium" and city="Mumbai";

-------------------------------------------

SELECT
    a.account_type,t.txn_type,
    SUM(CASE WHEN t.txn_type = 'Credit' THEN t.amount ELSE 0 END) AS credit_amount,
    SUM(CASE WHEN t.txn_type = 'Debit' THEN t.amount ELSE 0 END) AS debit_amount
FROM accounts a
JOIN transactions t
ON a.account_id = t.account_id
GROUP BY a.account_type;

-------------------------------------------
select c.full_name,count(a.account_id),sum(a.balance) as total_balance
from customers as c
right join accounts as a
on c.customer_id=a.customer_id
group by c.full_name
having count(a.account_type)>1

order by total_balance desc;

-------------------------------------


select *,total_balance*100/sum(total_balance) over(partition by city)as percentage,
dense_rank() over(partition by city order by total_balance desc) as rnk
from
(select c.full_name,c.city,sum(a.balance)as total_balance
from customers as c
right join accounts as a
on c.customer_id=a.customer_id
group by c.city,c.full_name
having count(a.account_id) >=1)x;

