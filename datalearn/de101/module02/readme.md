# Базы данных

## 2.1 Установка PostgreSQL

Что ж, начнем. Установка PostgreSQL на Windows вроде не отличается от установки любой другой программы, поэтому здесь все прошло без осложнений.

## 2.2 Подключение и загрузка таблиц в базу данных

### 2.2.1 Подключение

Подключение к базе данных с DBeaver также не вызвало проблем. В видео все очень подробно расказано.

### 2.2.1 Добавление информации из таблиц в БД

Однако добавление данных из таблиц заставило задуматься над поиском более компактного решения.
после 5 минут серфинга в интернете, было решено спользовать `Python` и необходимые модули: `pandas`, `sqlalchemy` (для чтения .xslx файлов `pandas` просит установить модуль `xlrd`

Код можно найти [здесь](./table_creating.py)

Есть один момент: при таком способе добавляется колонка `index`. Её можно удалить после добавления в БД двумя способами:

* используя команду

    ```SQL
    ALTER TABLE {table_name}
    DROP COLUMN index
    ```

    из DBeaver для каждой таблицы

* или добавить

    ```python
    # получаем список таблиц
    table_names = engine.table_names()

    # подключаемся к БД
    with engine.connect() as conn:

        # для каждой таблицы в списке
        for table in table_names:
            try:
                # удаляем колонку если она есть
                conn.execute(f'''
                                ALTER TABLE {table}
                                DROP COLUMN index
                            ''')
                print(f'deleted from {table}')
                
            except:
                # выводим сообщение что такой колонки в таблице нет
                print(f'there is no "index" in {table}')
    ```

не знаю, на сколько такой подход правильный в реальных условиях, но добавлять вручную построчно 10 000 строк, это не про меня :)

### 2.2.3 Получение данных из БД

параллельно штудируя курс по PostgreSQL, пробуем получать отчеты из БД

#### Overview (обзор ключевых метрик)

##### Total Sales

Суммируем продажи и округляем до целого

```SQL
select round(sum(o."Sales")) as "total sales"
from orders o
```

##### Total Profit

аналогично

```sql
select round(sum(o."Profit")) as "total profit"
from orders o
```

##### Profit Ratio

делим суммы профита и продаж и умножаем на 100

```sql
select round(
    (sum(o."Profit") / sum(o."Sales")
    )*100) as "total sales"
from orders o
```

##### Profit per Order

```sql
select o."Order ID" , 
    round(sum(o."Profit")) as "total profit"
from orders o
group by o."Order ID" 
order by "total profit" desc
```

##### Sales per Customer

```sql
select o."Customer ID", 
    round(sum(o."Profit")) as "total profit"
from orders o
group by o."Customer ID" 
order by "total profit" desc
```

##### Avg. Discount

```sql
select avg(o."Discount") * 100 as "avg discount"
from orders o
```

##### Monthly Sales by Segment

##### Monthly Sales by Product Category

#### Product Dashboard (Продуктовые метрики)

##### Sales by Product Category over time

#### Customer Analysis

##### Sales and Profit by Customer

```sql
select o."Customer ID", 
    round(sum(o."Sales")) as "total sales",
    round(sum(o."Profit")) as "total profit"
from orders o
group by o."Customer ID" 
order by "total profit" desc
```

##### Customer Ranking

##### Sales per region

```sql
select o."Region", 
    round(sum(o."Sales")) as "total sales"
from orders o
group by o."Region" 
order by "total sales" desc
```
