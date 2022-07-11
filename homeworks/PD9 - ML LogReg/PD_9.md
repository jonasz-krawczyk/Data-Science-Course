### Zad 3. Znajdź najlepsze dopasowanie wielomianowe dla regresji  medv do lstat. Na zbiorze testowm porównaj MSE ze zwykłym modlem liniowym dla tej zmeinnej

Kroki postepowania:

1. Dzielimy zbiór na treningowy i testowy
2. Na zbiorze treningowym uczymy model regresji zmiennej lstat do medv
3. Wyliczamy na zbiorze testowym predykcje i na ich podstawie porównując do wartości rzeczywisych wyliczamy MSE
4. Na zbiorze treningowym stosujemy GridSearchCV, który odpowie nam na pytanie który stopień wielomianu jest najlepszy
5. Na zbiorze treningowym uczymy model wielomianu odpowiedniego stopnia 
6. Na zbiorze testowym sprawdzamy MSE tego modelu jak w przypadku modelu zwykłej prostej regresji
7. Porówujemy oba wyniki i wskazujemy lepszy model.