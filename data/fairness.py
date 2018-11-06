__author__ = 'jvicens'

import pymysql
import csv
import sys

'''
                        HALF_ENDOWMENT  EQUAL_ENDOWMENT EQUAL_CONTRIBUTIONS

20MU's  Payoff           10              20              0*
        Contribution     10              0*              20
30MU's  Payoff           15              20              10
        Contribution     15              10              20
40MU's  Payoff           20              20              20
        Contribution     20              20              20
50MU's  Payoff           25              20              30
        Contribution     25              30              20
60MU's  Payoff           30              20              40
        Contribution     30              40              20

'''

def fairness_csv():
    db = pymysql.connect(user='root', passwd='', host='127.0.0.1', db='drbrain2')

    with db:

        c = db.cursor()
        c.execute("SELECT id, diners_inicials, diners_actuals, partida_id, acabat, is_robot FROM game_user")
        data_user = c.fetchall()
        c.execute("SELECT id, num_partida, diners_heterogenis, partida_024, estat, classe FROM game_partida")
        data_partida = c.fetchall()

        file0 = open('fairness.csv', 'wb')
        wr0 = csv.writer(file0, quoting=csv.QUOTE_ALL)


        user = {
            'id': 0,
            'unequal' : 0,
            'endowment': 0,
            'payoff': 0,
            'payoff_norm_half_endowment': 0,
            'payoff_norm_equal_payoff': 0,
            'contribution': 0,
            'contribution_norm_half_endowment': 0,
            'contribution_norm_equal_payoff': 0,
        }

        wr0.writerow(['id', 'unequal', 'endowment', 'payoff', 'payoff_norm_half_endowment', 'payoff_norm_equal_payoff', 'payoff_norm_equal_contribution', 'contribution', 'contribution_norm_half_endowment', 'contribution_norm_equal_payoff', 'contribution_norm_equal_contribution'])

        for u in data_user:

            user_array = []

            ## participant finished the game and is not a robot
            if u[4] == 1 and u[5] == 0:
                for p in data_partida:
                    ## identification of participants game
                    if p[0] == u[3]:
                        user['id'] = u[0]
                        user['unequal'] = p[2]
                        user['endowment'] = u[1]
                        user['payoff'] = u[2]
                        ## payoff based on 1/2 endowment (10, 15, 20, 25 and 30 MUs)
                        user['payoff_norm_half_endowment'] = u[2]/float((u[1]/float(2)))
                        ## payoff based on equal payoff (20 MUs)
                        user['payoff_norm_equal_payoff'] = u[2]/float(20)

                        ## all participants contribute the same 20MUs is 1.
                        ## participants with endowment of 20MUs (y = 3/20x + 1)
                        if u[1] == 20:
                            user['payoff_norm_equal_contribution'] = ((3.0/20.0)*u[2])+1
                        ## other participants with endowment different to 20MUs
                        else:
                            user['payoff_norm_equal_contribution'] = (u[2])/float(u[1]-20)

                        user['contribution'] = u[1] - u[2]
                        user['contribution_norm_half_endowment'] = (u[1] - u[2])/float((u[1]/float(2)))
                        user['contribution_norm_equal_contribution'] = (u[1] - u[2])/float(20)

                        ## participants with endowment of 20MUs (y = -3/20x + 4)
                        if u[1] == 20:
                            user['contribution_norm_equal_payoff'] = (-(3.0/20.0)*u[2])+4
                        ## other participants with endowment different to 20MUs
                        else:
                            user['contribution_norm_equal_payoff'] = (u[1] - u[2])/float(u[1]-20)

                        user_array.append(user['id'])
                        user_array.append(user['unequal'])
                        user_array.append(user['endowment'])
                        user_array.append(user['payoff'])
                        user_array.append(user['payoff_norm_half_endowment'])
                        user_array.append(user['payoff_norm_equal_payoff'])
                        user_array.append(user['payoff_norm_equal_contribution'])
                        user_array.append(user['contribution'])
                        user_array.append(user['contribution_norm_half_endowment'])
                        user_array.append(user['contribution_norm_equal_payoff'])
                        user_array.append(user['contribution_norm_equal_contribution'])

                        wr0.writerow(user_array)

        file0.close()


def main(argv):
    fairness_csv()

if __name__ == "__main__":
    main(sys.argv)


