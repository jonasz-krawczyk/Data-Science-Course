Wykonałem tu kilka wersji zadania pod kątem możliwych operacji preprocessingu.<br>
Każdym notebook zawiera różne wyniki i wnioski. Jeśli nie chce Ci się przeglądać wszystkich notebooków (co w pełni rozumiem) to otwórz tylko ten, który w mojej ocenie wygrywa, znaczy się "6_PD13_Jonasz-normalizacja_standaryzacja_+_PCA_.<br>
Tak czy inaczej podsumowanie wszystkiego jest tutaj poniżej.

------
Uwagi ogólne:

1. Dane przepuszczone przez filtr outlierów charakteryzują się może lepszą klasteryzacją i wariancją niższą o około 1/3 ale za to gubi się część miasta. W przypadku tego datasetu nie stosowałbym tego filtra i pozostawił outliery.

2. Próbowałem wielu kombinacji i w brew pozorom także pakowałem różne zmienne do feature_list 'ów. Problem jest rozwojowy, można w nieskończoność próbować zbiory różnych zmiennych. Zauważyłem, że na mapce chce klarować się zasadniczo 5 grup /co jest zgodne z moją intuicją ile ich powinno być/ ale niektóre z nich są dublowane. Przy próbie odkrycia tylko tych 5 grup mapka albo się rozmazuje (zmniejszanie wariancji) albo dzieli na 4 grupy (zmniejszanie ilosci featurów, zmniejszanie klastrów). Nie mam zaufania do podziału miasta na 4 obszary z uwagi na to, że objawia się on dla małej ilości featurów z czego połowa to współrzędne. Dodatkowo podejrzany jest charakterystyczny zarys wg. głównych kierunków N-S, E-W.

3. Na koniec rozważań dodałem także analizę PCA ale już tylko do notebooka który moim zdaniem dawał najlepsze rezultaty.

------

Wnioski z notebooków:
1. Dane wcale nie poddane obróbce wstępnej przez Scalery są tutaj w zasadzie nieporównywalnie gorsze (mają dużą wariancję i trudno czytelne mapy) z modelami pracującymi na wystandaryzowanych zmiennych. Nie polecam do stosowania.

2. Dane standaryzowane charakteryzują się bodaj najlepszym dobrym dopasowaniem klastrów ale za to mają dużą wariancję. Dobrze nadaje się do pokazania rezultatu komuś z ulicy.

3. W przypadku normalizacji widać, że wariancja jest dużo niższa, kompletnie w innej lidze do danych standaryzowanych. Niestety pojawia się problem z wizualnie dobrym dopasowaniem klastrów; jest to bardzo rozstrzelone, chociaż suma dystansów próbek do ich najbliższego centroidu (inertia) jest najmniejsza.
Przy normalizacji z usuniętymi outlierami wariancja o dziwo rośnie, ginie także część informacji, w tym przypadku nie jest to więc dobry pomysł.

4. W przypadku danych zarówno normalizowanych i standaryzowanych wariancja wzrosła około dwukrotnie (w por. do danych tylko normalizowanych) co i tak uważam za całkiem dobry rezultat, można było spodziewać się większego wzrostu. Tą drogą bym szedł do ewentualnej dalszej pracy nad tym zadaniem (doskonalenie modelu) - konkretnie mapka nr 2, która najbardziej do mnie trafia. Zawiera ona dostatecznie dużo zmiennych aby mówić o rzetelnym podziale oraz ma relatywnie znośną inercję. To mój faworyt. Popróbowałbym różnych zmiennych aby możliwie zmniejszyć ilosć klastrów. 

5. Analiza PCA choć pogorszyła wyniki to zadziałała korzystnie w stronę graficznego rozwiązania problemu klasteryzacji tego zbioru.
