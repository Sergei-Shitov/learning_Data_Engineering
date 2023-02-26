from datetime import datetime
from datetime import timedelta
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
import genTasks

default_args = {
    'owner': 'MrSaddy',
    'depends_on_past': False,
    'start_date': datetime(2023, 2, 1, 7, 0),
    'email': [{email}],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=1)
}

with DAG(
    'collect_data',
    default_args=default_args,
    max_active_runs=1,
    catchup=False,
    description='Getting data from hh.ru API and store it to one csv file in /temp_stg',
    schedule_interval=timedelta(days=1)
) as dag:

    getting_data = PythonOperator(
        task_id='getting_data',
        python_callable=genTasks.getting_data,
        dag=dag
    )

    assemble_data = PythonOperator(
        task_id='assemble_data',
        python_callable=genTasks.assemle_data,
        dag=dag
    )

    remove_json = BashOperator(
        task_id='clean_tmp_stg',
        bash_command='rm /way/to/temp_stg/*.json',
        dag=dag
    )

    getting_data >> assemble_data
    assemble_data >> remove_json
