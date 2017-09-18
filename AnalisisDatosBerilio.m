clear all
num = xlsread('Datos Electrodos y berilio.xlsx');
tiempos_traker = num(:,1);
valores_traker= num(:,2);
tiempos_flujo = num(:,);
valores_flujo = num(:,4);
tiempos_voltaje = num(:,5);
valores_voltaje= num(:,6);


%convertir los picos de voltaje en ceros
for i = 1:size(valores_voltaje,1)
    if (valores_voltaje(i) < 0)
        valores_voltaje(i) = 0; 
    end  
    if (valores_voltaje(i) > 0.9)
        valores_voltaje(i) = 0; 
    end  
end

%multiplicar los flujos y los votlajes por una escala
escala_flujo = 10;
escala_voltaje = 25;

valores_flujo = valores_flujo * escala_flujo;
valores_voltaje = valores_voltaje * escala_voltaje;

%trasladar los vectores por x segundos en la parte izquierda para compensar
%el retraso en la toma de video
tiempo_traslado_traker= 4;
tiempo_traslado_flujo = 7;
tiempo_traslado_voltaje = 7;


i = 1;
while(tiempos_traker(i) < tiempo_traslado_traker)
i = i+1;
end

valor_inicial = tiempos_traker(i);
tiempos_traker = tiempos_traker(i:end);
tiempos_traker = tiempos_traker - valor_inicial;
valores_traker = valores_traker(i:end);



i = 1;
while(tiempos_flujo(i) < tiempo_traslado_flujo)
i = i+1;
end

valor_inicial = tiempos_flujo(i);
tiempos_flujo = tiempos_flujo(i:end);
tiempos_flujo = tiempos_flujo - valor_inicial;
valores_flujo = valores_flujo(i:end);

i2 = 1;
while(tiempos_voltaje(i2) < tiempo_traslado_voltaje)
i2 = i2+1;
end

valor_inicial = tiempos_voltaje(i2);
tiempos_voltaje = tiempos_voltaje(i2:end);
tiempos_voltaje = tiempos_voltaje - valor_inicial;
valores_voltaje = valores_voltaje(i2:end);


%Se saca el valor integral flujo (que se acerca a flujo

i = 1;
j = 0;
k = 1;
integral_flujo = valores_flujo;

while(i<size(valores_flujo,1))
    
    while(tiempos_flujo(i)> tiempos_voltaje(k))
        k = k +1;
    end
    
    integral_flujo(i) = valores_voltaje(k)- valores_flujo(i)*20;
    
    if(abs(valores_voltaje(k) < 0.1))
       integral_flujo(i) = 0;
    end
    
    if(integral_flujo(i)< 0)
       integral_flujo(i) = 0;
    end
    
    i = i+1;
end

integral_flujo = integral_flujo * 1.4;


plot(tiempos_traker,valores_traker)
hold on
plot(tiempos_flujo,integral_flujo)
%hold on
%plot(tiempos_flujo,valores_flujo)
%hold on
%plot(tiempos_voltaje,valores_voltaje)


%se recorta un tiempo a la derecha
tiempo_recorte_derecha = 112;

i = 1;
while(tiempos_flujo(i) < tiempo_recorte_derecha)
i = i+1;
end

tiempos_flujo = tiempos_flujo(1:i); 
integral_flujo = integral_flujo(1:i);

j = 1;
while(tiempos_traker(j) < tiempo_recorte_derecha)
j = j+1;
end

tiempos_traker = tiempos_traker(1:j);
valores_traker = valores_traker(1:j);


%se hace la integración para saber el flujo que ha pasado
resolucion = 80;

i = floor(size(valores_traker,1)/resolucion);
j = floor(size(integral_flujo,1)/resolucion);

integ_trak = [];
integ_flujo = [];

n = 1;
while n < ((size(valores_traker,1) -n) )
q = trapz(tiempos_traker(n:n+i),valores_traker(n:n+i));
integ_trak = [integ_trak, q]
n = n + i;
end

m = 1;
while m < ((size(integral_flujo,1)- m))
p = trapz(tiempos_flujo(m:m+j),integral_flujo(m:m+j));
integ_flujo = [integ_flujo, p]
m = m + j;
end

