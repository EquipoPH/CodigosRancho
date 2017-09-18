clear all
num = xlsread('PruebaTornilloRancho.xlsx');
tiempos_flujo = num(:,1);
valores_flujo = num(:,2);
tiempos_voltaje = num(:,3);
valores_voltaje= num(:,4);


%convertir los picos de voltaje en ceros
for i = 1:size(valores_voltaje,1)
    if (valores_voltaje(i) < 0)
        valores_voltaje(i) = 0; 
    end  
    if (valores_voltaje(i) > 2)
        valores_voltaje(i) = 0; 
    end  
end

%convertir los picos de flujo en ceros
for i = 1:size(valores_flujo,1)
    if (valores_flujo(i) < 0)
        valores_flujo(i) = 0; 
    end  
    if (valores_flujo(i) > 5)
        valores_flujo(i) = 0; 
    end  
end

%multiplicar los flujos y los votlajes por una escala
escala_flujo = 1;
escala_voltaje = 1;

valores_flujo = valores_flujo * escala_flujo;
valores_voltaje = valores_voltaje * escala_voltaje;

%trasladar los vectores por x segundos en la parte izquierda para compensar
%el retraso en la toma de video
tiempo_traslado_flujo = 0;
tiempo_traslado_voltaje = 0;


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

tiempo_recorte_derecha = 320;

i = 1;
while(tiempos_flujo(i) < tiempo_recorte_derecha)
i = i+1;
end

tiempos_flujo = tiempos_flujo(1:i); 
valores_flujo = valores_flujo(1:i);




%for i = 1:size(valores_flujo,1)
%    if (valores_flujo(i) < 0)
%        valores_flujo(i) = 0; 
%    end   
%end

q = trapz(tiempos_flujo,valores_flujo);


plot(tiempos_flujo,valores_flujo)
hold on
plot(tiempos_voltaje,valores_voltaje)


