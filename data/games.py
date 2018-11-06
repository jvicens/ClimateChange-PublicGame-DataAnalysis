__author__ = 'jvicens'


import pymysql
import csv
import sys


def games_csv():

    db = pymysql.connect(user='root', passwd='', host='127.0.0.1', db='drbrain2')

    with db:

        c = db.cursor()
        c.execute("SELECT id, diners_inicials, diners_actuals, partida_id, acabat, is_robot FROM game_user")
        data_user = c.fetchall()
        c.execute("SELECT id, num_partida, diners_heterogenis, partida_024 FROM game_partida")
        data_partida = c.fetchall()
        c.execute("SELECT id, num_ronda, partida_id, bucket_inici_ronda, bucket_final_ronda FROM game_ronda")
        data_ronda = c.fetchall()
        c.execute("SELECT id, ha_seleccionat, seleccio, ronda_id, user_id FROM game_userronda")
        data_userronda = c.fetchall()

        contribuciones = []
        for row_partida in data_partida:
            if row_partida[2] == 0: #Homogenies
                for row_user in data_user:
                    if row_user[4] == 1 and row_user[5] == 0: # acabat = 1 and is_robot = 0
                        if row_user[3] == row_partida[0]:
                            if row_user[1] == 40:
                                contribuciones_ronda = {'homogenea': True, 'capital_inicial': 40, '024': False,
                                                        'ronda 1': 0, 'ronda 2': 0, 'ronda 3': 0,
                                                        'ronda 4': 0, 'ronda 5': 0, 'ronda 6': 0,
                                                        'ronda 7': 0, 'ronda 8': 0, 'ronda 9': 0,
                                                        'ronda 10': 0, 'partida': row_partida[0]}

                                if row_partida[3] == 1: contribuciones_ronda['024'] = True
                                else: contribuciones_ronda['024'] = False

                                for row_userronda in data_userronda:
                                    if row_userronda[4] == row_user[0]:
                                        for row_ronda in data_ronda:
                                            if row_ronda[0] == row_userronda[3]:
                                                if row_ronda[1] == 1: #num_ronda
                                                    contribuciones_ronda['ronda 1']=row_userronda[2]
                                                elif row_ronda[1] == 2: #num_ronda
                                                    contribuciones_ronda['ronda 2']=row_userronda[2]
                                                elif row_ronda[1] == 3: #num_ronda
                                                    contribuciones_ronda['ronda 3']=row_userronda[2]
                                                elif row_ronda[1] == 4: #num_ronda
                                                    contribuciones_ronda['ronda 4']=row_userronda[2]
                                                elif row_ronda[1] == 5: #num_ronda
                                                    contribuciones_ronda['ronda 5']=row_userronda[2]
                                                elif row_ronda[1] == 6: #num_ronda
                                                    contribuciones_ronda['ronda 6']=row_userronda[2]
                                                elif row_ronda[1] == 7: #num_ronda
                                                    contribuciones_ronda['ronda 7']=row_userronda[2]
                                                elif row_ronda[1] == 8: #num_ronda
                                                    contribuciones_ronda['ronda 8']=row_userronda[2]
                                                elif row_ronda[1] == 9: #num_ronda
                                                    contribuciones_ronda['ronda 9']=row_userronda[2]
                                                elif row_ronda[1] == 10: #num_ronda
                                                    contribuciones_ronda['ronda 10']=row_userronda[2]

                                contribuciones.append(contribuciones_ronda)

            if row_partida[2] == 1: #Heterogenea
                for row_user in data_user:
                    if row_user[4] == 1 and row_user[5] == 0: # acabat = 1 and is_robot = 0
                        if row_user[3] == row_partida[0]:
                            if row_user[1] == 20:
                                contribuciones_ronda = {'homogenea': False, 'capital_inicial': 20, '024': False,
                                                        'ronda 1': 0,
                                                        'ronda 2': 0, 'ronda 3': 0, 'ronda 4': 0, 'ronda 5': 0,
                                                        'ronda 6': 0, 'ronda 7': 0, 'ronda 8': 0, 'ronda 9': 0,
                                                        'ronda 10': 0, 'partida': row_partida[0]}

                                if row_partida[3] == 1: contribuciones_ronda['024'] = True
                                else: contribuciones_ronda['024'] = False

                                for row_userronda in data_userronda:
                                    if row_userronda[4] == row_user[0]:
                                        for row_ronda in data_ronda:
                                            if row_ronda[0] == row_userronda[3]:
                                                if row_ronda[1] == 1: #num_ronda
                                                    contribuciones_ronda['ronda 1']=row_userronda[2]
                                                elif row_ronda[1] == 2: #num_ronda
                                                    contribuciones_ronda['ronda 2']=row_userronda[2]
                                                elif row_ronda[1] == 3: #num_ronda
                                                    contribuciones_ronda['ronda 3']=row_userronda[2]
                                                elif row_ronda[1] == 4: #num_ronda
                                                    contribuciones_ronda['ronda 4']=row_userronda[2]
                                                elif row_ronda[1] == 5: #num_ronda
                                                    contribuciones_ronda['ronda 5']=row_userronda[2]
                                                elif row_ronda[1] == 6: #num_ronda
                                                    contribuciones_ronda['ronda 6']=row_userronda[2]
                                                elif row_ronda[1] == 7: #num_ronda
                                                    contribuciones_ronda['ronda 7']=row_userronda[2]
                                                elif row_ronda[1] == 8: #num_ronda
                                                    contribuciones_ronda['ronda 8']=row_userronda[2]
                                                elif row_ronda[1] == 9: #num_ronda
                                                    contribuciones_ronda['ronda 9']=row_userronda[2]
                                                elif row_ronda[1] == 10: #num_ronda
                                                    contribuciones_ronda['ronda 10']=row_userronda[2]

                                contribuciones.append(contribuciones_ronda)
                            if row_user[1] == 30:
                                contribuciones_ronda = {'homogenea': False, 'capital_inicial': 30, '024': False,
                                                        'ronda 1': 0,
                                                        'ronda 2': 0, 'ronda 3': 0, 'ronda 4': 0, 'ronda 5': 0,
                                                        'ronda 6': 0, 'ronda 7': 0, 'ronda 8': 0, 'ronda 9': 0,
                                                        'ronda 10': 0 , 'partida': row_partida[0]}

                                if row_partida[3] == 1: contribuciones_ronda['024'] = True
                                else: contribuciones_ronda['024'] = False

                                for row_userronda in data_userronda:
                                    if row_userronda[4] == row_user[0]:
                                        for row_ronda in data_ronda:
                                            if row_ronda[0] == row_userronda[3]:
                                                if row_ronda[1] == 1: #num_ronda
                                                    contribuciones_ronda['ronda 1']=row_userronda[2]
                                                elif row_ronda[1] == 2: #num_ronda
                                                    contribuciones_ronda['ronda 2']=row_userronda[2]
                                                elif row_ronda[1] == 3: #num_ronda
                                                    contribuciones_ronda['ronda 3']=row_userronda[2]
                                                elif row_ronda[1] == 4: #num_ronda
                                                    contribuciones_ronda['ronda 4']=row_userronda[2]
                                                elif row_ronda[1] == 5: #num_ronda
                                                    contribuciones_ronda['ronda 5']=row_userronda[2]
                                                elif row_ronda[1] == 6: #num_ronda
                                                    contribuciones_ronda['ronda 6']=row_userronda[2]
                                                elif row_ronda[1] == 7: #num_ronda
                                                    contribuciones_ronda['ronda 7']=row_userronda[2]
                                                elif row_ronda[1] == 8: #num_ronda
                                                    contribuciones_ronda['ronda 8']=row_userronda[2]
                                                elif row_ronda[1] == 9: #num_ronda
                                                    contribuciones_ronda['ronda 9']=row_userronda[2]
                                                elif row_ronda[1] == 10: #num_ronda
                                                    contribuciones_ronda['ronda 10']=row_userronda[2]

                                contribuciones.append(contribuciones_ronda)
                            if row_user[1] == 40:
                                contribuciones_ronda = {'homogenea': False, 'capital_inicial': 40, '024': False,
                                                        'ronda 1': 0,
                                                        'ronda 2': 0, 'ronda 3': 0, 'ronda 4': 0, 'ronda 5': 0,
                                                        'ronda 6': 0, 'ronda 7': 0, 'ronda 8': 0, 'ronda 9': 0,
                                                        'ronda 10': 0, 'partida': row_partida[0]}

                                if row_partida[3] == 1: contribuciones_ronda['024'] = True
                                else: contribuciones_ronda['024'] = False

                                for row_userronda in data_userronda:
                                    if row_userronda[4] == row_user[0]:
                                        for row_ronda in data_ronda:
                                            if row_ronda[0] == row_userronda[3]:
                                                if row_ronda[1] == 1: #num_ronda
                                                    contribuciones_ronda['ronda 1']=row_userronda[2]
                                                elif row_ronda[1] == 2: #num_ronda
                                                    contribuciones_ronda['ronda 2']=row_userronda[2]
                                                elif row_ronda[1] == 3: #num_ronda
                                                    contribuciones_ronda['ronda 3']=row_userronda[2]
                                                elif row_ronda[1] == 4: #num_ronda
                                                    contribuciones_ronda['ronda 4']=row_userronda[2]
                                                elif row_ronda[1] == 5: #num_ronda
                                                    contribuciones_ronda['ronda 5']=row_userronda[2]
                                                elif row_ronda[1] == 6: #num_ronda
                                                    contribuciones_ronda['ronda 6']=row_userronda[2]
                                                elif row_ronda[1] == 7: #num_ronda
                                                    contribuciones_ronda['ronda 7']=row_userronda[2]
                                                elif row_ronda[1] == 8: #num_ronda
                                                    contribuciones_ronda['ronda 8']=row_userronda[2]
                                                elif row_ronda[1] == 9: #num_ronda
                                                    contribuciones_ronda['ronda 9']=row_userronda[2]
                                                elif row_ronda[1] == 10: #num_ronda
                                                    contribuciones_ronda['ronda 10']=row_userronda[2]

                                contribuciones.append(contribuciones_ronda)
                            if row_user[1] == 50:
                                contribuciones_ronda = {'homogenea': False, 'capital_inicial': 50, '024': False,
                                                        'ronda 1': 0,
                                                        'ronda 2': 0, 'ronda 3': 0, 'ronda 4': 0, 'ronda 5': 0,
                                                        'ronda 6': 0, 'ronda 7': 0, 'ronda 8': 0, 'ronda 9': 0,
                                                        'ronda 10': 0, 'partida': row_partida[0]}

                                if row_partida[3] == 1: contribuciones_ronda['024'] = True
                                else: contribuciones_ronda['024'] = False

                                for row_userronda in data_userronda:
                                    if row_userronda[4] == row_user[0]:
                                        for row_ronda in data_ronda:
                                            if row_ronda[0] == row_userronda[3]:
                                                if row_ronda[1] == 1: #num_ronda
                                                    contribuciones_ronda['ronda 1']=row_userronda[2]
                                                elif row_ronda[1] == 2: #num_ronda
                                                    contribuciones_ronda['ronda 2']=row_userronda[2]
                                                elif row_ronda[1] == 3: #num_ronda
                                                    contribuciones_ronda['ronda 3']=row_userronda[2]
                                                elif row_ronda[1] == 4: #num_ronda
                                                    contribuciones_ronda['ronda 4']=row_userronda[2]
                                                elif row_ronda[1] == 5: #num_ronda
                                                    contribuciones_ronda['ronda 5']=row_userronda[2]
                                                elif row_ronda[1] == 6: #num_ronda
                                                    contribuciones_ronda['ronda 6']=row_userronda[2]
                                                elif row_ronda[1] == 7: #num_ronda
                                                    contribuciones_ronda['ronda 7']=row_userronda[2]
                                                elif row_ronda[1] == 8: #num_ronda
                                                    contribuciones_ronda['ronda 8']=row_userronda[2]
                                                elif row_ronda[1] == 9: #num_ronda
                                                    contribuciones_ronda['ronda 9']=row_userronda[2]
                                                elif row_ronda[1] == 10: #num_ronda
                                                    contribuciones_ronda['ronda 10']=row_userronda[2]
                                contribuciones.append(contribuciones_ronda)
                            if row_user[1] == 60:
                                contribuciones_ronda = {'homogenea': False, 'capital_inicial': 60, '024': False,
                                                        'ronda 1': 0,
                                                        'ronda 2': 0, 'ronda 3': 0, 'ronda 4': 0, 'ronda 5': 0,
                                                        'ronda 6': 0, 'ronda 7': 0, 'ronda 8': 0, 'ronda 9': 0,
                                                        'ronda 10': 0, 'partida': row_partida[0]}

                                if row_partida[3] == 1: contribuciones_ronda['024'] = True
                                else: contribuciones_ronda['024'] = False

                                for row_userronda in data_userronda:
                                    if row_userronda[4] == row_user[0]:
                                        for row_ronda in data_ronda:
                                            if row_ronda[0] == row_userronda[3]:
                                                if row_ronda[1] == 1: #num_ronda
                                                    contribuciones_ronda['ronda 1']=row_userronda[2]
                                                elif row_ronda[1] == 2: #num_ronda
                                                    contribuciones_ronda['ronda 2']=row_userronda[2]
                                                elif row_ronda[1] == 3: #num_ronda
                                                    contribuciones_ronda['ronda 3']=row_userronda[2]
                                                elif row_ronda[1] == 4: #num_ronda
                                                    contribuciones_ronda['ronda 4']=row_userronda[2]
                                                elif row_ronda[1] == 5: #num_ronda
                                                    contribuciones_ronda['ronda 5']=row_userronda[2]
                                                elif row_ronda[1] == 6: #num_ronda
                                                    contribuciones_ronda['ronda 6']=row_userronda[2]
                                                elif row_ronda[1] == 7: #num_ronda
                                                    contribuciones_ronda['ronda 7']=row_userronda[2]
                                                elif row_ronda[1] == 8: #num_ronda
                                                    contribuciones_ronda['ronda 8']=row_userronda[2]
                                                elif row_ronda[1] == 9: #num_ronda
                                                    contribuciones_ronda['ronda 9']=row_userronda[2]
                                                elif row_ronda[1] == 10: #num_rond
                                                    contribuciones_ronda['ronda 10']=row_userronda[2]
                                contribuciones.append(contribuciones_ronda)


        file = open('games.csv', 'wb')
        wr = csv.writer(file, quoting=csv.QUOTE_ALL)
        wr.writerow(["id","homogenea","valid_users","ronda1","ronda2","ronda3","ronda4","ronda5","ronda6","ronda7","ronda8","ronda9","ronda10"])

        for p in range(1,55,1):
            valid_users = 0
            rounds = [0,0,0,0,0,0,0,0,0,0]
            rounds_accumulate = []
            for c in contribuciones:
                if c['partida'] == p:
                    rounds[0] = rounds[0] + c['ronda 1']
                    rounds[1] = rounds[1] + c['ronda 2']
                    rounds[2] = rounds[2] + c['ronda 3']
                    rounds[3] = rounds[3] + c['ronda 4']
                    rounds[4] = rounds[4] + c['ronda 5']
                    rounds[5] = rounds[5] + c['ronda 6']
                    rounds[6] = rounds[6] + c['ronda 7']
                    rounds[7] = rounds[7] + c['ronda 8']
                    rounds[8] = rounds[8] + c['ronda 9']
                    rounds[9] = rounds[9] + c['ronda 10']
                    partida = c['partida']
                    classe = 1 if c['homogenea'] else 0
                    valid_users = valid_users + 1


            rounds_accumulate.append(rounds[0])
            rounds_accumulate.append(rounds[0]+rounds[1])
            rounds_accumulate.append(rounds[0]+rounds[1]+rounds[2])
            rounds_accumulate.append(rounds[0]+rounds[1]+rounds[2]+rounds[3])
            rounds_accumulate.append(rounds[0]+rounds[1]+rounds[2]+rounds[3]+rounds[4])
            rounds_accumulate.append(rounds[0]+rounds[1]+rounds[2]+rounds[3]+rounds[4]+rounds[5])
            rounds_accumulate.append(rounds[0]+rounds[1]+rounds[2]+rounds[3]+rounds[4]+rounds[5]+rounds[6])
            rounds_accumulate.append(rounds[0]+rounds[1]+rounds[2]+rounds[3]+rounds[4]+rounds[5]+rounds[6]+rounds[7])
            rounds_accumulate.append(rounds[0]+rounds[1]+rounds[2]+rounds[3]+rounds[4]+rounds[5]+rounds[6]+rounds[7]+rounds[8])
            rounds_accumulate.append(rounds[0]+rounds[1]+rounds[2]+rounds[3]+rounds[4]+rounds[5]+rounds[6]+rounds[7]+rounds[8]+rounds[9])

            wr.writerow([partida,
                         classe,
                         valid_users,
                         rounds_accumulate[0],
                         rounds_accumulate[1],
                         rounds_accumulate[2],
                         rounds_accumulate[3],
                         rounds_accumulate[4],
                         rounds_accumulate[5],
                         rounds_accumulate[6],
                         rounds_accumulate[7],
                         rounds_accumulate[8],
                         rounds_accumulate[9]])

        file.close()

def main(argv):
    games_csv()

if __name__ == "__main__":
    main(sys.argv)