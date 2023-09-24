// 7200 blocks as one day time interval
let n = 30

let balanceSum = constant(0);
for (let i = 0; i < n; i++) {
    let blockDiff = mul(constant(i), periodSize);
    let blockNum = sub(endBlock, blockDiff);
    let accountBal = getAccount(blockNum, wallet).balance().toCircuitValue();
    balanceSum = add(balanceSum, accountBal);
}
let balanceMean = div(balanceSum, constant(10));

addToCallback(balanceMean);
log(balanceMean);

let stdDevNumerator = constant(0);
for (let i = 0; i < n; i++) {
    let blockDiff = mul(constant(i), periodSize);
    let blockNum = sub(endBlock, blockDiff);
    let accountBal = getAccount(blockNum, wallet).balance().toCircuitValue();
    let x_i_sq = mul(accountBal, accountBal);
    let mu_sq = mul(balanceMean, balanceMean);
    let mu__x_i = mul(accountBal, balanceMean);
    let mu__x_i__2 = mul(constant(2), mu__x_i);
    // x_i^2 + mu^2 - 2*mu*x_i
    stdDevNumerator = add(stdDevNumerator, mu__x_i__2);
}

addToCallback(stdDevNumerator);
log(stdDevNumerator);

// add wallet input for Axiom:
// {
//  "wallet": "<our address>",
//  "endBlock": 150000,
//  "periodSize": 7200,
// }
