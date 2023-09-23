# ethnyuniswapv4hooks

1 hook trading hours (UTC 23:59 - 1:00) AND (UTC 12:00 - 17:00)
----
2 volatility oracle with VolatilityOracle.sol 
OR
volatility oracle by Ken form Uniswap https://github.com/ankitchiplunkar/v3-volatility-oracle : the function for getting volatility is: https://ankitchiplunkar.com/v3-volatility-oracle/howtouse/ 
OR 
volatility calculation from Axiom
OR 
post volatility on UMA
---

3 create two LP positions. 1 in +/- 2 volatility range (allocate 20% of LP position) and 2 in +/- 1 volatility range (allocate 80% of LP position).
---
### 


#TODO:

### make quick 4 min vid, include data explaining use of v4 hooks, when fees occur, how we deal with icnreasing/decreasing ranges with volatility.

## Foundry Uniswap V4 Setup 

```
forge install https://github.com/Uniswap/v4-core --no-commit
forge compile
```