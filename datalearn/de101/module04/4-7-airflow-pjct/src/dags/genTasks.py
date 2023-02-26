import requests
import pandas as pd
import pathlib
import json
from datetime import date
from sqlalchemy import create_engine as eng


def getting_data():

    # getting data from hh.ru API
    # read list with interesting positions
    with open('/way/to/vac_list.txt', 'r') as file:
        vac_list = file.read().split(',')[:-1]

    # request first page on each position
    for vacancy in vac_list:
        r = requests.get(
            f'https://api.hh.ru/vacancies?text={vacancy}&search_field=name&per_page=100&page=0')

        # save first file
        vac_text = vacancy.replace(' ', '_')

        with open(f'/way/to/temp_stg/{vac_text}_0.json', 'w') as file:
            file.write(r.text)

        j_resp = r.json()

        # get information from other pages
        for page in range(1, j_resp['pages']):
            res = requests.get(
                f'https://api.hh.ru/vacancies?text={vacancy}&search_field=name&per_page=100&page={str(page)}')

            # save file for each page
            with open(f'/way/to/temp_stg/{vac_text}_{page}.json', 'w') as file:
                file.write(res.text)

            print(f'Request {vacancy} page {page}')

        print(f'files for {vacancy} saved succesfully')

    print('all data was recived')


def assemle_data():
    # assemble data to one csv file

    # set basic variables
    result = pd.DataFrame(columns=[
        'vac_id',
        'vac_name',
        'vac_url',
        'area_id',
        'area_name',
        'salary_from',
        'salary_to',
        'salary_currency',
        'published_at',
        'created_at',
        'employer_name',
        'employer_url',
        'schedule_id',
        'request_text',
        'load_date'
    ])

    path = '/way/to/temp_stg/'
    dir = pathlib.Path(path)
    counter = 0

    # getting list of files in temp_stg folder
    file_list = [file.name for file in dir.iterdir()]

    if len(file_list) != 0:

        for file in file_list:
            if '.json' not in file:
                file_list.remove(file)

        # fo every file
        for file in file_list:

            # open file
            with open(path + file) as src:
                vacancies = json.load(src)

            for item in vacancies['items']:

                vac_string = []

                vac_string.append(item['id'])
                vac_string.append(item['name'])
                vac_string.append(item['alternate_url'])
                vac_string.append(item['area']['id'])
                vac_string.append(item['area']['name'])

                if item['salary'] == None:
                    vac_string.append('')
                    vac_string.append('')
                    vac_string.append('')
                else:
                    vac_string.append(item['salary']['from'])
                    vac_string.append(item['salary']['to'])
                    vac_string.append(item['salary']['currency'])

                vac_string.append(item['published_at'])
                vac_string.append(item['created_at'])
                vac_string.append(item['employer']['name'])

                if 'alternate_url' in item['employer']:
                    vac_string.append(item['employer']['alternate_url'])
                else:
                    vac_string.append('')

                vac_string.append(item['schedule']['id'])
                vac_string.append(file.split('.')[0][:-2])
                vac_string.append(date.today())

                result.loc[max(result.index) + 1
                           if len(result.index) != 0
                           else 0] = vac_string
                counter += 1

    print(f'succesefuly loaded {counter} lines')

    # save assembled table to csv
    result.to_csv(
        '/way/to/temp_stg/result.csv', index=False)


def stg_filling():

    # geting IP address for connecting to win based Postgres DB from WSL
    with open('/etc/resolv.conf') as file:
        ip_file = file.read()

    ip_arr = ip_file.split('\n')
    db_ip = ip_arr[-2].split(' ')[-1]
    print(db_ip)

    # read result file
    df = pd.read_csv('/way/to/temp_stg/result.csv')

    # connect to DB
    conn = eng(f'postgresql://{username}:{password}@{db_ip}:5432/{db_name}')

    try:
        # load to stg DB
        df.to_sql({table_name}, conn, schema={schema_name}, index=False,
                  if_exists='append', method='multi')
    except:
        print('No DB connection')
