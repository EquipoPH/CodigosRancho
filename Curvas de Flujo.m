clear all
num = xlsread('Pruebas Tornillo Rancho Madero Completas.xlsx');
tiempos_voltaje = num(:,1);
valores_voltaje= num(:,2);

tiempo_traslado_voltaje = 0;

tiempo_recorte_derecha = 250;

i = 1;
while(tiempos_voltaje(i) < tiempo_traslado_voltaje)
i = i+1;
end

valor_inicial = tiempos_voltaje(i);
tiempos_voltaje = tiempos_voltaje(i:end);
tiempos_voltaje = tiempos_voltaje - valor_inicial;
valores_voltaje = valores_voltaje(i:end);

if(tiempo_recorte_derecha ~= 0)

i = 1;
while(tiempos_voltaje(i) < tiempo_recorte_derecha)
i = i+1;
end

tiempos_voltaje = tiempos_voltaje(1:i); 
valores_voltaje = valores_voltaje(1:i);

end

diferencias_voltaje = valores_voltaje;

for i = 1:(size(valores_voltaje,1)-1)
    diferencias_voltaje(i) = abs(valores_voltaje(i+1) - valores_voltaje(i)); 
    if (diferencias_voltaje(i) > 5)
        diferencias_voltaje(i) = 0; 
    end
end



plot(tiempos_voltaje,valores_voltaje)
q = trapz(tiempos_voltaje,diferencias_voltaje);
