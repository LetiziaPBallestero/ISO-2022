#!/bin/bash

echo "Primer numero" 
read num1
echo "Segundo numero"
read num2

echo "Multiplicación: "$((num1*num2))
echo "Suma: "$((num1 + num2))
echo "Resta: "$((num1-num2))

if [[$num1 > $num2]]
then
echo $num1 "es mayor que" $num2
else
echo $num2 "es mayor que" $num1
fi