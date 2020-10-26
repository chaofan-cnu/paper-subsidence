import pandas as pd
from datetime import timedelta

def ipt_linear(d, method):
    print("--- interpolate ---")
    helper = pd.DataFrame({'date': pd.date_range(d['date'].min(), d['date'].max(), freq='d')})
    print(helper)
    d = pd.merge(d, helper, on='date', how='outer').sort_values('date')
    d.interpolate(method=method, limit_direction='forward', axis=0, inplace=True)
    #print(d[0:5])
    return d

def main():
    excel_file = r'data16_18.xls'
    df = pd.DataFrame(pd.read_excel(excel_file))
    # format 2011-10
    reco=[]
    for val in df.columns:
        r = '{}-{}-{}'.format(str(val)[1:5],str(val)[5:7],str(val)[7:9])
        reco.append(r)
    df.columns = reco

    df = df.T
    df['date'] = reco
    df['date'] = pd.to_datetime(df['date'])
    
    #print(df[0:5])
    method = 'linear'
    df = ipt_linear(df, method)
    df = df.T
    #print(df[0:5])

    df.to_csv('interpolate16_18.csv')

if __name__ == '__main__':
    main()

