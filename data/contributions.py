__author__ = 'julian'

import pymysql
import csv
import numpy as np
import sys

def binning(step, data, data_position):

    bins = range(0, 120, step)
    x_binned = []

    for b in bins:
        index = [data_index for data_index, data_value in enumerate(data_position) if data_value >= b and data_value < (b + step)]

        if len(index) > 0:
            x_binned.append(np.mean([data[i] for i in index]))
        else:
            x_binned.append(np.nan)

    index = [data_index for data_index, data_value in enumerate(data_position) if data_value >= 120]

    if len(index) > 0:
        x_binned.append(np.mean([data[i] for i in index]))
    else:
        x_binned.append(np.nan)

    bins.append(120)

    return [x_binned, bins]


def contributions_csv(bin):
    db = pymysql.connect(user='root', passwd='', host='127.0.0.1', db='drbrain2')

    with db:

        c = db.cursor()
        c.execute("SELECT id, diners_inicials, diners_actuals, partida_id, acabat, is_robot FROM game_user")
        data_user = c.fetchall()
        c.execute("SELECT id, num_partida, diners_heterogenis, partida_024, estat, classe FROM game_partida")
        data_partida = c.fetchall()
        c.execute("SELECT id, num_ronda, partida_id, bucket_inici_ronda, bucket_final_ronda FROM game_ronda")
        data_ronda = c.fetchall()
        c.execute("SELECT id, ha_seleccionat, seleccio, ronda_id, user_id FROM game_userronda")
        data_userronda = c.fetchall()


        file = open('contributions.csv', 'wb')
        wr = csv.writer(file, quoting=csv.QUOTE_ALL)

        ## Create the header of csv
        binning_array = []

        binning_array.append('id')
        binning_array.append('unequal')
        for i in range(0,120, bin):
            binning_array.append(i)
        binning_array.append('>120')

        wr.writerow(binning_array)

        print 'Header binning created'

        for u in data_user:
            for p in data_partida:
                if p[0] == u[3] and u[4] == 1: # Identification of finished users game
                    ## capital accumulate in each game
                    capital_accumulate = [120 - r[3] for r in data_ronda if r[2] == p[0]]
                    ## users contributions
                    contributions = [ur[2] for ur in data_userronda if ur[4] == u[0]]
                    ## binning
                    b = binning(bin, contributions, capital_accumulate)

                    binning_array = []
                    ## identifier
                    binning_array.append(u[0])
                    binning_array.append(p[2])
                    for s in b[0]:
                        ## contributions normalized
                        s = (s*10)/(float(u[1]))
                        binning_array.append(s)

                    ## Games finished in DAU
                    if p[4] == 'ACABADA' and p[5] == 'DAU':
                        wr.writerow(binning_array)
                        print '..'+str(u[0])

        file.close()
        print 'Close file'

def main(argv):
    contributions_csv(bin=24)

if __name__ == "__main__":
    main(sys.argv)