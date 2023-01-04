# importing modules for DataBase and for working with tables

import pandas as pd
from sqlalchemy import create_engine

# create Data Frames from each sheet in Excel file

orders = pd.read_excel('Path\\to\\Sample_Superstore.xls',
                       sheet_name='Orders'
                       )
people = pd.read_excel('Path\\to\\Sample_Superstore.xls',
                       sheet_name='People'
                       )
returns = pd.read_excel('Path\\to\\Sample_Superstore.xls',
                        sheet_name='Returns'
                        )

# make engine for working with DataBase

engine = create_engine(
    'postgresql://{username}:{password}@localhost:5432/{db_name}')

# add our Data Frames to DataBase

try:
    orders.to_sql('orders', engine)
    people.to_sql('people', engine)
    returns.to_sql('returns', engine)

    print('tables were loaded')

except:
    print('failed')
