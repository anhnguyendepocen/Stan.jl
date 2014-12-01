######### Stan program example  ###########

using Stan

old = pwd()
ProjDir = Pkg.dir("Stan", "Examples", "Bernoulli")
cd(ProjDir)

bernoulli = "
data { 
  int<lower=0> N; 
  int<lower=0,upper=1> y[N];
} 
parameters {
  real<lower=0,upper=1> theta;
} 
model {
  theta ~ beta(1,1);
    y ~ bernoulli(theta);
}
"

data = [
  (ASCIIString => Any)["N" => 10, "y" => [0, 1, 0, 1, 0, 0, 0, 0, 0, 1]],
  (ASCIIString => Any)["N" => 10, "y" => [0, 1, 0, 0, 0, 0, 1, 0, 0, 1]],
  (ASCIIString => Any)["N" => 10, "y" => [0, 1, 0, 0, 0, 0, 0, 0, 1, 1]],
  (ASCIIString => Any)["N" => 10, "y" => [0, 0, 0, 1, 0, 0, 0, 1, 0, 1]]
]


stanmodel = Stanmodel(Optimize(), name="bernoulli", model=bernoulli, data=data);

optim = stan(stanmodel, data, ProjDir, CmdStanDir=CMDSTAN_HOME);
optim[1] |> display

cd(old)
