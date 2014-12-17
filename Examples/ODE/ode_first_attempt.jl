######### Stan program example  ###########

using Mamba, Stan, Compat

old = pwd()
ProjDir = normpath(homedir(), "Projects", "Julia", "Rob", "Support_Stan", "ODE")
cd(ProjDir)

odemodel = "
functions {
       real[] sho(real t,
                  real[] y,
                  real[] theta,
                  real[] x_r,
                  int[] x_i) {
         real dydt[2];
         dydt[1] <- y[2];
         dydt[2] <- -y[1] - theta[1] * y[2];
         return dydt;
        }
}

data {
  int<lower=1> T;
  int<lower=1> M;
  real t0;
  #real y0[M];
  real ts[T];
  real y[T,M];
}

transformed data {
  real x_r[0];
  int x_i[0];
}

parameters {
  real y0[2];
  vector<lower=0>[2] sigma;
  real theta[1];
}

model {
  real y_hat[T,2];
  sigma ~ cauchy(0,2.5);
  theta ~ normal(0,1);
  y0 ~ normal(0,1);
  y_hat <- integrate_ode(sho, y0, t0, ts, theta, x_r, x_i);
  for (t in 1:T)
   y[t] ~ normal(y_hat[t], sigma);
}
"

odedict =
  @Compat.Dict(
    "T" => 100, 
    "M" => 2,
    "t0" => 0,
    "y0" =>[1, 0],
    "ts" => linspace(0.1, 10, 100),
    "y" => reshape(
    [1.18447214273212, 0.931328995894153, 1.15546788943838,
    1.11347639821441, 0.942770215168461, 0.599435493714444, 0.633508944792969,
    0.664145932981416, 0.636983924087869, 0.922765008328693, 0.596380019171069,
    0.278177612651595, 0.139369448614547, 0.179787763946766, 0.0891127323154026,
    -0.0169426249192601, -0.00570968277658015, -0.263912169092685,
    -0.148772505096642, -0.480382763289494, -0.404896182791746, -0.386328653102745,
    -0.489160545877774, -0.448720573538264, -0.631560016157571, -0.594120804164941,
    -0.546128595678147, -0.844353075954525, -0.957296903080828, -0.773557074171747,
    -0.823902983465925, -0.870022238251538, -0.845805547618517, -0.862822747019435,
    -0.633621387892182, -0.54005323688692, -0.52759594518313, -0.698260966423782,
    -0.399851384871993, -0.57417194227814, -0.210773536528394, -0.328691086366792,
    -0.415888595882974, -0.405460494417675, -0.386540582062706, -0.301225587058244,
    -0.305429707660651, 0.172795987572527, 0.193262969285858, 0.101787696286287,
    0.240887604250816, 0.206580592212456, 0.687874694334188, 0.256891132411694,
    0.417940378943263, 0.508702198428123, 0.603583494034937, 0.518963474603121,
    0.239370958898509, 0.405413842254413, 0.664537334395703, 0.61855117823015,
    0.482298625607209, 0.602981201676457, 0.488960693669512, 0.632472522128953,
    0.361607240790125, 0.604105168457383, 0.555260897330889, 0.491905227250743,
    0.444851458749041, 0.43665875657333, 0.253492488343665, 0.282978685637294,
    0.348245354984117, 0.359853365329113, 0.161227722113711, 0.0663877602751073,
    -0.108375655042251, -0.242273836124497, -0.200186428760795, 0.0551064659674957,
    -0.0674686721293205, -0.263935344013016, -0.339446542506593, -0.379888014913294,
    -0.205050970863634, -0.429446704363204, -0.228811177404085, -0.344775841425698,
    -0.266696154615485, -0.607526316761665, -0.485276356000595, -0.623683758487882,
    -0.402186147508401, -0.468862353806569, -0.519585081598368, -0.244708739840049,
    -0.410221061395796, -0.272425410718381, 0.0181904776900387, -0.312235493264689,
    -0.381368486156188, -0.37097995457925, -0.631447866640104, -0.453475182715527,
    -0.803672414768249, -0.432186904480258, -0.807890489400406, -0.529710418827556,
    -0.88352798312236, -0.998941025325834, -0.871810569861829, -0.884996699488221,
    -1.14562740835939, -0.731091370545707, -1.04389586568583, -0.803924418504678,
    -0.750210634933026, -0.76615209369324, -0.759865803866824, -0.660889360648131,
    -0.793258906688218, -0.690430982604711, -0.66929377044793, -0.193522247444425,
    -0.130968185844238, -0.238937181200586, -0.38435217993569, -0.120257530068827,
    0.186771342421634, -0.0324051426644301, 0.236004465629662, 0.045278615833121,
    0.366831904664821, 0.18841113450848, 0.211083941237886, 0.311481217801157,
    0.378327568947026, 0.420127897626007, 0.709620445789031, 0.643849729991572,
    0.613348386811806, 0.520286542950945, 0.545129657971766, 0.589478472290371,
    0.536722990830953, 0.630499864509491, 0.754715456167985, 0.486532397567358,
    0.857517549562448, 0.407717911256268, 0.551895261585553, 0.878724986192702,
    0.609205971465613, 0.386122525791358, 0.238987436773361, 0.398304899982967,
    0.248882597950643, 0.132786785682916, 0.173995860263871, -0.0100293452254933,
    0.39937911504977, 0.190839430703432, -0.004520398638622, -0.0726269219830769,
    -0.31655229056679, -0.15460224391486, -0.388478202676613, -0.532056186725431,
    -0.138588618642611, -0.595854661880176, -0.531027468041037, -0.604247540619453,
    -0.673722368761153, -0.455905727528453, -0.782762232356633, -0.587995350317593,
    -0.640490312145211, -0.754692905495262, -0.543258607376073, -0.578773929440613,
    -0.579598805944238, -0.315701576014008, -0.350936596499424, -0.408500418636149,
    -0.332210426245586, -0.424089753625995, -0.299022180880827, -0.0568205107389459,
    -0.176479238422781, -0.100509704966414, 0.22863110851166, -0.130938638084811,
    0.167944957592579, 0.340641058030672, -0.0407477745000139, 0.16645548196369,
    0.147962705604123, 0.172782087145017], 100, 2))

odedata = [
  odedict,
  odedict,
  odedict,
  odedict
]

stanmodel = Stanmodel(name="ode", model=odemodel, nchains=4);

println("\nStanmodel that will be used:")
stanmodel |> display
println("Input observed data dictionary:")
odedata |> display
println()

sim1 = stan(stanmodel, odedata, ProjDir, diagnostics=false, CmdStanDir=CMDSTAN_HOME);

## Subset Sampler Output to variables suitable for describe().
monitor = ["theta.1", "lp__", "accept_stat__"]
sim = sim1[:, monitor, :]
describe(sim)
println()

p = plot(sim, [:trace, :mean, :density, :autocor], legend=true);
draw(p, ncol=4, filename="$(stanmodel.name)-summaryplot", fmt=:svg)
draw(p, ncol=4, filename="$(stanmodel.name)-summaryplot", fmt=:pdf)

## Subset Sampler Output to variables suitable for describe().
monitor = ["y0.1", "y0.2", "sigma.1", "sigma.2"]
sim = sim1[:, monitor, :]
describe(sim)
println()

p = plot(sim, [:trace, :mean, :density, :autocor], legend=true);
draw(p, nrow=4, ncol=4, filename="$(stanmodel.name)-sigmaplot", fmt=:svg)
draw(p, nrow=4, ncol=4, filename="$(stanmodel.name)-sigmaplot", fmt=:pdf)

# Below will only work on OSX, please adjust for your environment.
# JULIA_SVG_BROWSER is set from environment variable JULIA_SVG_BROWSER
@osx ? if isdefined(Main, :JULIA_SVG_BROWSER) && length(JULIA_SVG_BROWSER) > 0
        for i in 1:4
          isfile("$(stanmodel.name)-summaryplot-$(i).svg") &&
            run(`open -a $(JULIA_SVG_BROWSER) "$(stanmodel.name)-summaryplot-$(i).svg"`)
          isfile("$(stanmodel.name)-sigmaplot-$(i).svg") &&
            run(`open -a $(JULIA_SVG_BROWSER) "$(stanmodel.name)-sigmaplot-$(i).svg"`)
        end
      end : println()

cd(old)
