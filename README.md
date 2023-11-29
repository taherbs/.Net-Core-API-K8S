# Running a .Net Core Web API on Docker and K8S

## Setting up .Net Core Web API
We can start with a .net core web api as an example. The application will run on Docker. To create it, we can proceed with the terminal command below.

```
dotnet new webapi -o WeatherAPI
```
This will create a project with necessary structure. Run the api by typing following on terminal.

you can run the API on your local machine using the below command:
```
cd WeatherAPI 
dotnet run # Run application in DEV mode
```

## Run application using Docker/Docker-Compose

### Using Docker
```
docker build -t weather-api .
docker run -p 8080:8080 -e ASPNETCORE_URLS='http://*:8080' weather-api
```

You can reach to the application by browsing to the exposed port:
```
curl http://localhost:8080/weatherForecast
```
### Using Docker-Compose
```
docker-compose build
docker-compose up
```

You can reach to the application by browsing to the exposed port:
```
curl http://localhost:8080/weatherForecast
```
## Run application using K8S

```
kubectl apply -f k8s-deployment-service-weather-api.yaml # will deploy the weather-api service but will not expose it
kubectl apply -f k8s-deployment-service-ngnix-rev-proxy.yaml # will work as a reverse proxy for the weather-api
kubectl delete -f k8s-deployment-service-weather-api.yaml # delete weather-api resources
kubectl delete -f k8s-deployment-service-ngnix-rev-proxy.yaml # delete reverse proxy resources
kubectl get all # Get deployment status
kubectl logs <Pod_Name> # to get a pod logs
kubectl exec -it <Pod_Name> -- sh # ssh to pod
```

if you want to enable the k8s metrics server on your local docker desktop deploy the `k8s-metrics-server.yaml` service.
```
kubectl apply -f k8s-metrics-server.yaml # deploy metrics server.
kubectl -n kube-system get all # validate that the metrics service has been properly deployed.
kubectl top pods # get pods usage 
kubectl top nodes # get nodes usage
```

You can reach to the application by browsing to the exposed port:
```
curl http://localhost:80/weatherForecast
```