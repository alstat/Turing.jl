include("naive.bayes-stan.data.jl")
include("naive.bayes-stan.model.jl")

stan_model_name = "Naive_Bayes"
nbstan = Stanmodel(name=stan_model_name, model=naivebayesstanmodel, nchains=1);

nb_stan_sim = stan(nbstan, nbstandata, CmdStanDir=CMDSTAN_HOME, summary=false);
# nb_stan_sim.names

stan_d_raw = Dict()
for i = 1:4, j = 1:10
  stan_d_raw["phi[$i][$j]"] = nb_stan_sim[1:1000, ["phi.$i.$j"], :].value[:]
end

stan_d = Dict()
for i = 1:4
  stan_d["phi[$i]"] = mean([[stan_d_raw["phi[$i][$k]"][j] for k = 1:10] for j = 1:1000])
end

nb_time = get_stan_time(stan_model_name)
