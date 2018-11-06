__author__ = 'jvicens'

'''
    Creation of csv with these information

    ----------------
    User information
    ----------------
    ID identifier
    Unequal 1 Heterogeneous game / 0 Homogeneous game
    Payoff
    Payoff normalized by endowment
    Contribution
    Contribution normalized by endowment

'''

import pymysql
import csv
import sys

def users_csv():
    db = pymysql.connect(user='root', passwd='', host='127.0.0.1', db='drbrain2')

    with db:

        c = db.cursor()
        c.execute("SELECT id, diners_inicials, diners_actuals, partida_id, acabat, is_robot, rang_edat FROM game_user")
        data_user = c.fetchall()
        c.execute("SELECT id, num_partida, diners_heterogenis, partida_024, estat, classe FROM game_partida")
        data_partida = c.fetchall()

        file0 = open('users.csv', 'wb')
        wr0 = csv.writer(file0, quoting=csv.QUOTE_ALL)

        wr0.writerow(['id', 'unequal', 'endowment', 'payoff', 'payoff_norm', 'contribution', 'contribution_norm'])

        for u in data_user:

            user_array = []

            user = {
                'id': 0,
                'unequal': 0,
                'endowment': 0,
                'payoff': 0,
                'payoff_norm': 0,
                'contribution': 0,
                'contribution_norm': 0,
            }

            if u[4] == 1 and u[5] == 0:
                for p in data_partida:
                    if p[0] == u[3]: # identificam la partida per aquesta user
                        user['id'] = u[0]
                        user['unequal'] = p[2]
                        user['endowment'] = u[1]
                        user['payoff'] = u[2]
                        user['payoff_norm'] = u[2]/float((u[1]/float(1)))
                        user['contribution'] = u[1] - u[2]
                        user['contribution_norm'] = (u[1] - u[2])/float((u[1]/float(1)))

                        user_array.append(user['id'])
                        user_array.append(user['unequal'])
                        user_array.append(user['endowment'])
                        user_array.append(user['payoff'])
                        user_array.append(user['payoff_norm'])
                        user_array.append(user['contribution'])
                        user_array.append(user['contribution_norm'])

                        wr0.writerow(user_array)

        file0.close()

def main(argv):
    users_csv()

if __name__ == "__main__":
    main(sys.argv)


