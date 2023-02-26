from datetime import datetime
from datetime import timedelta
from datetime import date
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
import genTasks

default_args = {
    'owner': 'MrSaddy',
    'depends_on_past': False,
    'start_date': datetime(2023, 2, 1, 7, 15),
    'email': [{email}],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=1)
}

with DAG(
    'stg_load',
    default_args=default_args,
    max_active_runs=1,
    catchup=False,
    description='add recived data to stg',
    schedule_interval=timedelta(days=1)
) as dag:

    load_to_stg = PythonOperator(
        task_id='load_to_stg',
        python_callable=genTasks.stg_filling,
        dag=dag
    )

    rename_res = BashOperator(
        task_id='rename_res',
        bash_command=f'mv /way/to/temp_stg/result.csv /way/to/temp_stg/result_{date.today()}.csv',
        dag=dag
    )

    load_to_stg
