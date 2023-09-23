import numpy as np
import statsmodels as sm
import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns

df= pd.read_csv('fee_history.csv')
df=df.sort_values(by='day_hr',ascending=True)
df.set_index('day_hr')
df.index=pd.to_datetime(df.index)
df['day_hr']=pd.to_datetime(df['day_hr'])
df["day"] = df["day_hr"].dt.day_name()
df["UTC-hour"] = df["day_hr"].dt.hour

g=df.groupby(['day','UTC-hour'])['total_fees_usd'].sum()/1000000
new_df=g.reset_index()

plt.figure(figsize=(9,9))
plt.suptitle("Uniswap Sum of Fee Generation Since v3 Inception in Millions")
plt.title("Notice the increase at 0:00-1:00 and 13:00-17:00 UTC \n we want to capture the red/orange ranges with our hook")


a=new_df.pivot(index='UTC-hour',columns='day', values='total_fees_usd')
a = a.reindex(['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'], axis=1)
a = a.iloc[::-1]
sns.heatmap(a, cmap="Spectral_r", annot=True, fmt='.0f',  linewidth=0)
plt.savefig("uniswap_heatmap_hook.jpg", dpi=300)

draw=df['total_fees_usd']
df["ma"] = draw.rolling (24).mean()
df["ma2"] = draw.rolling (24).mean()
plt.figure(figsize=(18,8))
plt.title("We observe that fees spike when volatility increases. We want to capture this by widening our ranges with a hook.")
plt.suptitle("Uniswap v3 Hourly Fees in Millions since Inception [05/05/2021-28/07/2023]")
plt.plot(np.arange(0,len(draw)), draw, linewidth=0.17, color='#25a0d8')
plt.plot(np.arange(0,len(draw)), np.arange(0,len(draw))*0, linewidth=0.5, color='k')
plt.plot(np.arange(0,len(df["ma2"])), df["ma2"], linewidth=0.75, color='#854dc9')
plt.axis([0, 19530, 0, 20])
plt.ylabel('Fees in Millions of Dollars')
plt.xlabel('Elapsed Hours since v3 launch')
plt.grid(False)
plt.ylim((0,1280000))
plt.legend(['Hourly Fees','24-Hours Moving Average'])
plt.show
plt.savefig("uniswap_fees_hook.jpg", dpi=300)