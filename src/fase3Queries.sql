/***************** APARTADO 1 *****************/
/* 1.1
 * Enumerar el nom i el valor de dany de les cartes de tipus de tropa amb un valor de
 * velocitat d’atac superior a 100 i el nom del qual contingui el caràcter "k".
 */
select c.nombre, c.daño
from carta c join tropas t on c.nombre = t.carta
where velocidad_ataque > 100 and (c.nombre like '%k%' or c.nombre like '%K%');

--Validación

select c.nombre, c.velocidad_ataque
from carta c join tropas t on c.nombre = t.carta
order by c.velocidad_ataque desc;


/* 1.2
 * Enumerar el valor de dany mitjà, el valor de dany màxim i el valor de dany mínim de les
 * cartes èpiques.
 */
select avg(daño) as daño_medio, max(daño) as daño_max, min(daño) as daño_min
from carta
group by rareza having rareza = 'Epic';

--Query para comprobar que los valores son correctos.
select nombre, daño, rareza from carta order by daño desc;

/* 1.3
 * Enumera el nom i la descripció de les piles i el nom de les cartes que tenen un nivell de
 * carta més gran que el nivell mitjà de totes les cartes. Ordena els resultats segons el nom
 * de les piles i el nom de les cartes de més a menys valor.
 */
select d.titulo, d.descripcion, c2.nombre, c.nivel
from deck d join compuesto c on d.id = c.deck
join carta c2 on c.carta = c2.nombre
where c.nivel > (select avg(nivel) from compuesto)
order by d.titulo desc, c2.nombre desc;


/* 1.4
 * Enumerar el nom i el dany de les cartes llegendàries de menor a major valor de dany
 * que pertanyin a una pila creada l'1 de novembre del 2021. Filtrar la sortida per tenir les
 * deu millors cartes.
 */
select c.nombre, c.daño
from carta c join compuesto c2 on c.nombre = c2.carta
join deck d on c2.deck = d.id
where c.rareza = 'Epic' and d.fecha = '2021-11-01'
group by c.nombre, c.daño
order by c.daño desc
limit 10;

--Query para comprobar que los valores son correctos.
select titulo from deck where fecha = '2021-11-01';


/* 1.5
 * Llistar les tres primeres cartes de tipus edifici (nom i dany) en funció del dany dels
 * jugadors amb experiència superior a 250.000.
 * Base de dades: 2021-2022 Projecte – Fase 3
 */
select c.nombre, c.daño
from edificio ed join carta c on c.nombre = ed.carta
join encuentra e on c.nombre = e.carta
join jugador j on e.jugador = j.id
where j.experiencia > 250000
group by c.nombre, c.daño
order by c.daño desc
limit 3;

--Query de validación
select c.nombre, c.daño, j.nombre, j.experiencia
from edificio ed join carta c on c.nombre = ed.carta
join encuentra e on c.nombre = e.carta
join jugador j on e.jugador = j.id
where j.experiencia > 250000
order by c.daño desc;


/* 1.6
 * Els dissenyadors del joc volen canviar algunes coses a les dades. El nom d'una carta
 * "Rascals" serà "Hal Roach's Rascals", la Raresa "Common" es dirà "Proletari".
 * Proporcioneu les ordres SQL per fer les modificacions sense eliminar les dades i
 * reimportar-les.
 */
--Update rareza
update carta
set rareza = 'Common'
where rareza like 'Proletari';

--Update nombre
update carta
set nombre = 'Hal Roach''s Rascals'
where nombre like 'Rascals';

update compuesto
set carta = 'Hal Roach''s Rascals'
where carta = 'Rascals';

update encuentra
set carta = 'Hal Roach''s Rascals'
where carta = 'Rascals';

update tropas
set carta = 'Hal Roach''s Rascals'
where carta = 'Rascals';

/********************************************************************/
/*****************Queries de validación pre update*******************/
/********************************************************************/
--update rareza
select *
from carta
where rareza = 'Common'
order by nombre;

--update nombre
select *
from carta
where carta.nombre = 'Rascals';

select *
from compuesto
where carta = 'Rascals'
order by deck;

select *
from encuentra
where carta = 'Rascals'
order by jugador;

select carta, daño_aparicion, 'tropas' as tipo
from tropas
where carta = 'Rascals';

/**************************************************************************/
/********************Queries de validación post update*********************/
/**************************************************************************/
--Update rareza
select *
from carta
where rareza = 'Proletari'
order by nombre;

--update nombre
select *
from carta
where carta.nombre = 'Hal Roach''s Rascals';

select *
from compuesto
where carta = 'Hal Roach''s Rascals'
order by deck;

select *
from encuentra
where carta = 'Hal Roach''s Rascals'
order by jugador;

select carta, daño_aparicion, 'Hal Roach''s Rascals' as tipo
from tropas
where carta = 'Hal Roach''s Rascals';






/* 1.7
 * Enumerar els noms de les cartes que no estan en cap pila i els noms de les cartes que
 * només estan en una pila. Per validar els resultats de la consulta, proporcioneu dues
 * consultes diferents per obtenir el mateix resultat.
 */

--Query 1
select c.nombre
from carta c left join compuesto c2 on c.nombre = c2.carta
where c2.carta is null
union
select c.nombre
from carta c join compuesto c2 on c.nombre = c2.carta
group by c.nombre having count(c2.carta) = 1;

--Query 2
select c.nombre
from carta c
where c.nombre not in (select compuesto.carta from compuesto)
union
select c.nombre
from carta c join compuesto c2 on c.nombre = c2.carta
group by c.nombre having count(c2.carta) = 1;


--Comprobacion que solo hay 2 cartas con 0 decks y ninguna con 1 deck
select c.nombre, count(c2.carta)
from carta c left join compuesto c2 on c.nombre = c2.carta
group by c.nombre having count(c2.carta) < 2;


/* 1.8
 * Enumera el nom i el dany de les cartes èpiques que tenen un dany superior al dany mitjà
 * de les cartes llegendàries. Ordena els resultats segons el dany de les cartes de menys
 * a més valor.
 */

select nombre, daño
from carta
where rareza = 'Epic' and daño > (select avg(daño) from carta where rareza = 'Legendary')
order by daño;

--Query de validación
select nombre, daño
from carta
where rareza = 'Epic'
order by daño;

select avg(daño) from carta where rareza = 'Legendary';
/***************** APARTADO 2 *****************/
/* 2.1
 * Enumera els missatges (text i data) escrits pels jugadors que tenen més experiència que
 * la mitjana dels jugadors que tenen una "A" en nom seu i pertanyen al clan "NoA". Donar
 * la llista de ordenada dels missatges més antics als més nous.
 */
select m.cuerpo, m.fecha
from jugador j join escribe e on j.id = e.id_emisor
join mensaje m on e.id_mensaje = m.id
where j.experiencia > (
    select avg(experiencia)
    from jugador j join formado f on j.id = f.jugador
    join clan c on f.clan = c.id
    where (j.nombre like '%a%' or j.nombre like '%A%') and c.nombre = 'NoA')
order by m.fecha;

--Consultas de validación
select j.nombre, experiencia
from jugador j join formado f on j.id = f.jugador
join clan c on f.clan = c.id
where (j.nombre like '%a%' or j.nombre like '%A%') and  c.nombre = 'NoA';

select avg(experiencia)
from jugador j join formado f on j.id = f.jugador
join clan c on f.clan = c.id
where (j.nombre like '%a%' or j.nombre like '%A%') and  c.nombre = 'NoA';

select j.nombre, j.experiencia, c.nombre
from jugador j join formado f on j.id = f.jugador
join clan c on c.id = f.clan
where c.nombre = 'NoA';

select m.cuerpo, m.fecha, j.experiencia
from jugador j join escribe e on j.id = e.id_emisor
join mensaje m on e.id_mensaje = m.id
where j.nombre = 'King Tyler'
order by m.fecha desc;

/* 2.2
 * Enumera el número de la targeta de crèdit, la data i el descompte utilitzat pels jugadors
 * per comprar articles de Pack Arena amb un cost superior a 200 i per comprar articles
 * que el seu nom contingui una "B".
 */
select c.tarjeta, c.fecha, c.descuento
from compra c join jugador j on c.jugador = j.id
join articulo a on c.articulo = a.id
join paquete_arena pa on a.id = pa.id_paquete
where a.coste_real > 200
union
select c.tarjeta, c.fecha, c.descuento
from compra c join jugador j on c.jugador = j.id
join articulo a on c.articulo = a.id
join paquete_arena pa on a.id = pa.id_paquete
where a.nombre like '%b%' or a.nombre like '%B%';

--Conslutas de veridificación
select a.nombre, a.coste_real
from compra c join jugador j on c.jugador = j.id
join articulo a on c.articulo = a.id
join paquete_arena pa on a.id = pa.id_paquete;

select a.nombre, a.coste_real
from compra c join jugador j on c.jugador = j.id
join articulo a on c.articulo = a.id
join paquete_arena pa on a.id = pa.id_paquete;

/* 2.3
 * Enumerar el nom i el nombre d’articles comprats, així com el cost total dels articles
 * comprats i l’experiència dels jugadors que els van demanar. Filtra la sortida amb els 5
 * articles en què els usuaris han gastat més diners.
 */
select a.nombre, count(c.articulo) as num_compras, a.coste_real*count(c.articulo) as coste_total, avg(j.experiencia) as experiencia
from compra c join articulo a on c.articulo = a.id
join jugador j on c.jugador = j.id
group by a.id
order by coste_total desc
limit 5;

--Consultas de validación
select a.coste_real, j.nombre, j.experiencia
from compra c join articulo a on c.articulo = a.id
join jugador j on c.jugador = j.id
where a.nombre = 'White Goldenrod';

/* 2.4
 * Donar els números de les targetes de crèdit que s'han utilitzat més.
 */
select t.numero_tarjeta
from compra c join tarjeta t on c.tarjeta = t.numero_tarjeta
group by t.numero_tarjeta having count(c.tarjeta) = (
    select count(c.tarjeta)
    from compra c join tarjeta t on c.tarjeta = t.numero_tarjeta
    group by t.numero_tarjeta
    order by count(c.tarjeta) desc
    limit 1);


/* 2.5
 * Donar els descomptes totals de les emoticones comprades durant l'any 2020
 */
select sum(c.descuento)
from compra c join articulo a on c.articulo = a.id
join emoticono e on a.id = e.id_emoticono
where c.fecha between '2020-01-01' and '2020-12-31';

--Consulta de validación
select c.descuento, extract(year from c.fecha)
from compra c join articulo a on c.articulo = a.id
join emoticono e on a.id = e.id_emoticono;


/* 2.6
 * Enumerar el nom, experiència i número de targeta de crèdit dels jugadors amb
 * experiència superior a 150.000. Filtra les targetes de crèdit que no han estat utilitzades
 * per comprar cap article. Donar dues consultes diferents per obtenir el mateix resultat.
 */

 --Query 1
select j.nombre, j.experiencia, t.numero_tarjeta
from jugador j join tarjeta t on j.tarjeta = t.numero_tarjeta
left join compra c on j.id = c.jugador
where c.jugador is null and experiencia > 150000;


--Query 2
select j.nombre, j.experiencia, t.numero_tarjeta
from jugador j join tarjeta t on j.tarjeta = t.numero_tarjeta
where j.experiencia > 150000 and t.numero_tarjeta not in (
        select distinct tarjeta
        from compra
    );


--Podemos ver que solo hay un jugador que no ha comprado ningun articulo, por lo tanto
--la query anterior es correcta
select count(distinct jugador) as num_jugadores
from compra;

select numero_tarjeta
from tarjeta
except
select tarjeta
from compra;



/* 2.7
 * Retorna el nom dels articles comprats pels jugadors que tenen més de 105 cartes o pels
 * jugadors que han escrit més de 4 missatges. Ordeneu els resultats segons el nom de
 * l'article de més a menys valor.
 */
select distinct a.nombre
from jugador j join compra c on j.id = c.jugador
join articulo a on c.articulo = a.id
where j.id in (
    select j.id -- Jugadores con mas de 105 cartas
    from jugador j join encuentra e on j.id = e.jugador
    group by j.id having count(e.carta) > 105
    UNION
    select j.id -- Jugadores con mas de 4 mensajes escritos
    from jugador j join escribe e on j.id = e.id_emisor
    group by j.id having count(e.id_mensaje) > 4
    )
order by a.nombre desc;


/*  2.8
 * Retorna els missatges (text i data) enviats a l'any 2020 entre jugadors i que hagin estat
 * respostos, o els missatges sense respostes enviats a un clan. Ordena els resultats
 * segons la data del missatge i el text del missatge de més a menys valor.
 */
select distinct j.cuerpo, j.fecha
from mensaje j join mensaje j2 on j.id = j2.idmensajerespondido
union all
select cuerpo, fecha
from mensaje_clan
where id in (
    select m.id
    from mensaje_clan m left join mensaje_clan m2 on m2.mensaje_respondido = m.id
    where m2.id is null
    )
order by fecha desc, cuerpo desc;

--Validaciones primera parte
select distinct j.id, j.cuerpo, j.fecha, j2.id as Respuesta
from mensaje j join mensaje j2 on j.id = j2.idmensajerespondido;

select *
from mensaje
where idmensajerespondido = 287;

--Validaciones segunda parte
select cuerpo, fecha, id
from mensaje_clan
where id in (
    select m.id
    from mensaje_clan m left join mensaje_clan m2 on m2.mensaje_respondido = m.id
    where m2.id is null
)
order by fecha desc, cuerpo desc;

select count(id)
from mensaje_clan
where mensaje_respondido = 683;

/***************** APARTADO 3 *****************/
/* 3.1
 * Llistar els clans (nom i descripció) i el nombre de jugadors que tenen una experiència
 * superior a 200.000. Filtra la sortida per tenir els clans amb més trofeus requerits.
 */
select c.nombre as clan, c.descripcion, count(f.jugador) as num_judaors_XP200000
from clan c join formado f on c.id = f.clan join jugador j on j.id = f.jugador
where j.experiencia > 200000 and c.minimo_trofeos = (select max(minimo_trofeos) from clan)
group by c.nombre, c.descripcion, c.minimo_trofeos
order by c.minimo_trofeos desc;--TODO: He añadido la subquery para que solo escogiera los clanes que tienen tantos trofeos como el que más.

-- Query de validació: aquells clans que cumpleixin el contrari al requisit
select c.nombre as clan, c.descripcion, count(f.jugador) as num_judaors_XP200000
from clan c join formado f on c.id = f.clan join jugador j on j.id = f.jugador
where j.experiencia < 200000 and c.minimo_trofeos < (select max(minimo_trofeos) from clan)
group by c.nombre, c.descripcion, c.minimo_trofeos
order by c.minimo_trofeos desc;

/* 3.2
 * Llistar els 15 jugadors amb més experiència, la seva experiència i el nom del clan que pertany
 * si el clan que ha investigat una tecnologia amb un cost superior a 1000.
 */
select distinct j.nombre, j.experiencia, c.nombre
from jugador as j join formado f on j.id = f.jugador join clan c on c.id = f.clan
                  join clan_modificador cm on c.id = cm.clan join modificador m on cm.modificador = m.nombre
                  join tecnologias t on m.nombre = t.nombre
where m.coste_oro > 1000
order by j.experiencia desc limit 15;--TODO: He utilizado el distinct en vez del group by

-- Query de validació: el mateix objectiu utilitzant un altre cami
select j.nombre
from jugador j join formado f on f.jugador = j.id
where f.clan in (select c.id
                 from tecnologias t
                          join modificador m on t.nombre = m.nombre
                          join clan_modificador cm on m.nombre = cm.modificador
                          join clan c on cm.clan = c.id
                 where m.coste_oro > 1000)
order by j.experiencia desc limit 15;

select nombre, experiencia from jugador order by experiencia desc;

/* 3.3
 * Enumera l’identificador, la data d'inici i la durada de les batalles que van començar després del "01-01-2021" i en
 * què van participar clans amb trofeus mínims superiors a 6900. Donar només 5 batalles amb la major durada.
 */
select b.id, b.fecha, b.durada
from batalla as b join batalla_clan bc on bc.id = b.batalla_clan
join pelea p on bc.id = p.batalla_clan join clan c on c.id = p.clan
where b.fecha > '01-01-2021' and c.minimo_trofeos > 6900
group by b.id, b.fecha, b.durada
order by durada desc limit 5;


/* 3.4
 * Enumera per a cada clan el nombre d'estructures i el cost total d'or. Considera les estructures creades a l'any 2020
 * i amb trofeus mínims superiors a 1200. Donar només la informació dels clans que tinguin més de 2 estructures.
 */
select c.nombre as nombre2, count(e.nombre) as nombre_estructuras, sum(m.coste_oro) as coste_total_oro
from clan as c left join clan_modificador cm on c.id = cm.clan
join modificador m on cm.modificador = m.nombre join estructura e on m.nombre = e.nombre
where cm.fecha >= '01-01-2020' and cm.fecha <= '31-12-2020' and c.minimo_trofeos > 1200
group by c.nombre having count(e.nombre) > 2;


/* 3.5
 * Enumera el nom dels clans, la descripció i els trofeus mínims ordenat de menor a major nivell de trofeus mínims per
 * als clans amb jugadors que tinguin més de 200.000 d’experiència i el rol co-líder.
 */
select distinct c.nombre, c.descripcion, c.minimo_trofeos
from clan c join formado f on c.id = f.clan join jugador j on j.id = f.jugador
where j.experiencia > 200000 and f.role LIKE 'coLeader%'
order by c.minimo_trofeos asc; --TODO: Cambiado el group by por el distinct, más optimo

-- Query de validació
select distinct c.nombre, c.descripcion, c.minimo_trofeos
from clan c join (select distinct f.clan, f.jugador
                from formado f join jugador j on f.jugador = j.id
                where role like 'coLeader%' and j.experiencia > 200000) as Q1 on q1.clan = c.id
order by c.minimo_trofeos asc;

/* 3.6
 * Necessitem canviar algunes dades a la base de dades. Hem d'incrementar un 25% el cost de les tecnologies que
 * utilitzen els clans amb trofeus mínims superiors a la mitjana de trofeus mínims de tots els clans.
 */
update modificador
set coste_oro = coste_oro + coste_oro*0.25
where nombre in (
    select m.nombre
    from tecnologias t left join modificador m on t.nombre = m.nombre
    join clan_modificador cm on m.nombre = cm.modificador
    where cm.clan in (
        select id
        from clan
        where minimo_trofeos > (select avg(minimo_trofeos) from clan)
    )
    group by m.nombre
    );


/* 3.7
 * Enumerar el nom i la descripció de la tecnologia utilitzada pels clans que tenen una estructura "Monument"
 * construïda després del "01-01-2021". Ordena les dades segons el nom i la descripció de les tecnologies.
 */
select distinct t.nombre, m.descripcion
from tecnologias t join modificador m on t.nombre = m.nombre
                   join clan_modificador cm on m.nombre = cm.modificador
                   join clan c on cm.clan = c.id
where c.nombre in (
    select c2.nombre
    from clan c2 join clan_modificador cm2 on c2.id = cm2.clan
                 join modificador m2 on cm2.modificador = m2.nombre
                 join estructura e2 on m2.nombre = e2.nombre
    where e2.nombre like 'Monument' and cm2.fecha > '01-01-2021'
    )
order by t.nombre, m.descripcion;--TODO: He puesto la fecha correcta y he cambiado el group by por el distinct.


-- Afegim una estrctura nova
insert into modificador(nombre, coste_oro, descripcion, daño, vel_ataque, daño_aparicion, radio, vida, dependencia)
values ('#newTech', 320, '5.7 validation', 2,4, null, 2, 1, null);

insert into tecnologias(nombre, nivel_max, dep_level)
VALUES ('#newTech', 4, 5);

insert into clan_modificador(clan, modificador, nivel, fecha)
values ('#1ABCDEF8', 'Monument', 6, '02-01-2021');

insert into clan_modificador(clan, modificador, nivel, fecha)
values ('#1ABCDEF8', '#newTech', 7, '02-01-2021');
select * from clan_modificador where modificador like 'Monument';

/* 3.8
 * Enumera els clans amb un mínim de trofeus superior a 6900 i que hagin participat a totes les batalles de clans.
 */

--Query del enunciado
select c.nombre
from clan c join pelea p on p.clan = c.id join batalla_clan bc on bc.id = p.batalla_clan
where c.minimo_trofeos > 6900
group by c.id, c.nombre having count(distinct bc.id) = (select count(distinct id) from batalla_clan);


/***************** APARTADO 4 *****************/
/* 4.1
 * Enumera el nom, els trofeus mínims, els trofeus màxims de les arenes que el seu títol comença per "A" i tenen un
 * paquet d’arena amb or superior a 8000.
 */
select a.nombre, a.max_trofeos, a.min_trofeos
from arena a
         join nivel_arena na on a.id = na.arena
         join paquete_arena pa on na.paquete = pa.id_paquete
where oro >= 8000
group by a.nombre, a.max_trofeos, a.min_trofeos
having nombre like 'A%';

/* query de validacion */
select DISTINCT (arena)
from nivel_arena
         join arena a on a.id = nivel_arena.arena
where oro > 8000
  and a.nombre like 'A%'
order by arena;


/* 4.2
 * Llista de nom, data d'inici, data de finalització de les temporades i, de les batalles d'aquestes temporades, el nom
 * del jugador guanyador si el jugador té més victòries que derrotes i la seva experiència és més gran de 200.000.
 */
select t.nombre,
       t.fecha_inicio,
       t.fecha_final,
       j.nombre  as nombre_jugador,
       d.jugador as id_jugador
from temporada as t
         join participa p on t.nombre = p.temporada
         join jugador as j on p.jugador = j.id
         join deck d on j.id = d.jugador
         join batalla b on d.id = b.deck_win
where b.fecha >= t.fecha_inicio
  and b.fecha <= t.fecha_final
  and j.id in (select w.jugador
               from (select d.jugador, COUNT(d.id) as num_wins
                     from deck d
                              join batalla b on d.id = b.deck_win
                     group by d.jugador) as w
                        join (select d.jugador, COUNT(d.id) as num_loses
                              from deck d
                                       join batalla b on d.id = b.deck_lose
                              group by d.jugador) as l on w.jugador = l.jugador
               where w.num_wins - l.num_loses > 0
                 and w.jugador in (select jj.id
                                   from jugador jj
                                   where jj.experiencia > 200000))
order by t.fecha_inicio asc;


-- Validacion
-- devolvemos el numero de victorias y de derrotas de todos los jugadores y que tengan mas victorias que derrotas
select w.jugador, w.num_wins, l.num_loses, w.num_wins - l.num_loses as difference
from (select d.jugador, COUNT(d.id) as num_wins
      from deck d
               join batalla b on d.id = b.deck_win
      group by d.jugador) as w
         join (select d.jugador, COUNT(d.id) as num_loses
               from deck d
                        join batalla b on d.id = b.deck_lose
               group by d.jugador) as l on w.jugador = l.jugador
where w.num_wins - l.num_loses > 0
  and w.jugador in (select j.id
                    from jugador j
                    where j.experiencia > 200000);


/* 4.3
 * Llistar la puntuació total dels jugadors guanyadors de batalles de cada temporada. Filtrar la sortida per considerar
 * només les temporades que han començat i acabat el 2019.
 */
select t.nombre as temporada,
       j.nombre  as nombre_jugador,
       d.jugador as id_jugador,
       SUM(b.puntos_win) as suma_puntos
from temporada as t
         join participa p on t.nombre = p.temporada
         join jugador as j on p.jugador = j.id
         join deck d on j.id = d.jugador
         join batalla b on d.id = b.deck_win
where b.fecha >= t.fecha_inicio
  and b.fecha <= t.fecha_final
  and EXTRACT(YEAR FROM t.fecha_inicio) = 2019
  and EXTRACT(YEAR FROM t.fecha_final) = 2019
  and j.id in (select w.jugador
               from (select d.jugador
                     from deck d
                              join batalla b on d.id = b.deck_win
                     group by d.jugador) as w)
group by t.nombre, j.nombre, d.jugador
order by t.nombre asc, suma_puntos desc;


/* Validaciones */
/* Devolvemos una lista con los trofeos que han conseguido en la temporada 2019 */
select j.nombre,
       SUM(b.puntos_win) as total_points
from jugador j,
     batalla b,
     deck d
where b.deck_win = d.id
  and j.id = d.jugador
  and EXTRACT(YEAR FROM b.fecha) = 2019
group by j.nombre
order by total_points desc;

/* 4.4
 * Enumerar els noms de les arenes en què els jugadors veterans (experiència superior a 170.000) van obtenir insígnies
 * després del "25-10-2021". Ordenar el resultat segons el nom de l’arena en ordre ascendent.
 */
select a.nombre
from arena a,
     jugador j,
     insignia i,
     consigue c
where j.experiencia > 170000
  and c.jugador = j.id
  and a.id = c.arena
  and i.nombre = c.insignia
  and c.fecha >= '2021-10-25'
group by a.nombre
order by a.nombre asc;

/* Query de validacio */
select *
from arena
where arena.nombre not in (select a.nombre
                           from arena a,
                                jugador j,
                                insignia i,
                                consigue c
                           where j.experiencia > 170000
                             and c.jugador = j.id
                             and a.id = c.arena
                             and i.nombre = c.insignia
                             and c.fecha >= '2021-10-25'
                           group by a.nombre);


/* 4.5
 * Enumerar el nom de la insígnia, els noms de les cartes i el dany de les cartes dels jugadors amb una experiència
 * superior a 290.000 i obtingudes en arenes el nom de les quals comença per "A" o quan la insígnia no té imatge. Així,
 * considera només els jugadors que tenen una carta el nom de la qual comença per "Lava".
 */
select distinct i.nombre, c.nombre, c.daño
from insignia i join consigue co on i.nombre = co.insignia join jugador j on co.jugador = j.id
                join encuentra e on j.id = e.jugador join carta c on c.nombre = e.carta
                join arena a on a.id = c.arena
where (j.experiencia > 290000 and a.nombre like 'A%') or i.imagenurl is null
    and j.nombre in (select j.nombre
                     from carta c join encuentra e on c.nombre = e.carta join jugador j on e.jugador = j.id
                     where c.nombre like 'Lava%')
order by i.nombre, c.nombre, c.daño;


-- Query de validacion
select * from insignia where imagenurl is null;


/* 4.6
 * Donar el nom de les missions que donen recompenses a totes les arenes el títol de les quals comença per "t" o acaba
 * per "a". Ordena el resultat pel nom de la missió.
 */
select m.nombre as nombre_mission, a.nombre as nombre_arena
from mision as m
         join mision_arena ma on m.id = ma.mision
         join arena as a on ma.arena = a.id
where a.nombre like 'T%'
   or a.nombre like '%a'
order by m.nombre asc;


/* 4.7
 * Donar el nom de les arenes amb jugadors que al novembre o desembre de 2021 van obtenir insígnies si el nom de
 * l’arena conté la paraula "Lliga", i les arenes tenen jugadors que al 2021 van obtenir èxits el nom dels quals conté
 * la paraula "Friend".
 */
select a.nombre as nombre_arena
from consigue as c
         join arena a on a.id = c.arena
         join jugador j on j.id = c.jugador
         join insignia i on i.nombre = c.insignia
where a.nombre like '%Lliga%'
  and EXTRACT(YEAR FROM c.fecha) = 2021
  and (EXTRACT(MONTH FROM c.fecha) = 11 or EXTRACT(MONTH FROM c.fecha) = 12)
  and j.id in (select j.id
               from desbloquea d
                        join arena a on a.id = d.arena
                        join jugador j on j.id = d.jugador
                        join logro l on l.id = d.id_logro
               where l.nombre like '%Friend%'
                 and EXTRACT(YEAR FROM d.fecha) = 2021
               group by j.id)
group by a.nombre
order by a.nombre;

/* He cambiado la palabra "Lliga" por "Legendary" para que salga algun resultado ya que ninguna arena lleva la palabra LLiga */
select a.nombre as nombre_arena
from consigue as c
         join arena a on a.id = c.arena
         join jugador j on j.id = c.jugador
         join insignia i on i.nombre = c.insignia
where a.nombre like '%Legendary%'
  and EXTRACT(YEAR FROM c.fecha) = 2021
  and (EXTRACT(MONTH FROM c.fecha) = 11 or EXTRACT(MONTH FROM c.fecha) = 12)
  and j.id in (select j.id
               from desbloquea d
                        join arena a on a.id = d.arena
                        join jugador j on j.id = d.jugador
                        join logro l on l.id = d.id_logro
               where l.nombre like '%Friend%'
                 and EXTRACT(YEAR FROM d.fecha) = 2021
               group by j.id)
group by a.nombre
order by a.nombre;

/* 4.8
 * Retorna el nom de les cartes que pertanyen a jugadors que van completar missions el nom de les quals inclou la
 * paraula "Armer" i l'or de la missió és més gran que l'or mitjà recompensat en totes les missions de les arenes.
 */
select c.nombre as nombre_carta
from carta c
         join encuentra e on c.nombre = e.carta
         join jugador j on e.jugador = j.id
where j.id in (select j2.id
               from jugador j2
                        join realiza r on j2.id = r.jugador
                        join mision m on r.mision = m.id
                        join mision_arena ma on m.id = ma.mision
               where m.descripcion like '%Armer%'
                 and ma.recompensa_oro > (select AVG(mision_arena.recompensa_oro) as media from mision_arena)
               group by j2.id
)
group by c.nombre;


/***************** APARTADO 5 *****************/

/* 5.1
 * Mostrar el nombre de jugadors que té cada clan, però només considerant els jugadors amb nom de rol que
 * contingui el text "elder". Restringir la sortida per als 5 primers clans amb més jugadors.
 */
select c.nombre, count(distinct f.jugador) as num_players
from clan as c  join formado f on c.id = f.clan
where f.role like '%elder:%'
group by c.nombre order by num_players desc limit 5;

--Consulta per la validacó
select c.nombre, count(distinct f.jugador) as num_players, f.jugador, f.role
from clan as c join formado f on c.id = f.clan
where f.role like '%elder:%'
group by c.nombre,f.jugador, f.role order by num_players;




/* 5.2
 *  Mostrar el nom dels jugadors,el text dels missatges i la data dels missatges enviats pels jugadors
 *  que tenen la carta Skeleton Army i han comprat articles abans del 01-01-2019.
 */
select j.nombre, m.cuerpo, m.fecha
from jugador as j join escribe e on j.id = e.id_emisor
join mensaje m on m.id = e.id_mensaje join deck d on j.id = d.jugador
join compuesto c on d.id = c.deck join compra c2 on j.id = c2.jugador
where c.carta like 'Skeleton Army' and c2.fecha < '2019-01-01'
group by j.nombre, m.cuerpo, m.fecha;


----Consulta per a la validacio
select j.nombre, m.cuerpo, m.fecha, c.carta,c2.fecha
from jugador as j join escribe e on j.id = e.id_emisor
                  join mensaje m on m.id = e.id_mensaje join deck d on j.id = d.jugador
                  join compuesto c on d.id = c.deck join compra c2 on j.id = c2.jugador
where c.carta like 'Skeleton Army' and c2.fecha < '2019-01-01'
group by j.nombre, m.cuerpo, m.fecha,c.carta,c2.fecha;


/* 5.3
 *  Llistar els 10 primers jugadors amb experiència superior a 100.000 que han creat més piles i han guanyat
 *  batalles a la temporada T7.
 */
---------------------------

--Query de la 5.3
select j.nombre, count(d.jugador) as decks_creats
    from jugador as j join deck d on j.id = d.jugador
        join batalla b on d.id = b.deck_win
    where j.experiencia > 100000 and b.fecha between '2020-01-01' and '2020-08-31'
    group by j.nombre order by decks_creats desc limit 10;


--Query valdiacio
select j.nombre, b.fecha
    from jugador as j join deck d on j.id = d.jugador join batalla b on d.id = b.deck_win
    where b.fecha between '2020-01-01' and '2020-08-31' and
      (j.nombre like '%Ktown%' or j.nombre like '%WINNER%' or j.nombre like '%KingSquid%' or j.nombre like '%Alan%'
      or j.nombre like '%Jessie%' or j.nombre like '%VORTEX%' or j.nombre like '%wayes%' or j.nombre like '%QLASH%'
      or j.nombre like '%Dirso%' or j.nombre like '%Yogui%')
    group by j.nombre, b.fecha;

---Query2 validacio
select j.nombre, count(d.jugador) as decks_creats, j.experiencia
    from jugador as j join deck d on j.id = d.jugador
                  join batalla b on d.id = b.deck_win
    where j.experiencia > 100000 and b.fecha between '2020-01-01' and '2020-08-31'
    group by j.nombre,j.experiencia, j.nombre order by decks_creats desc limit 10;

/* 5.4
 * Enumera els articles que han estat comprats més vegades i el seu cost total.
 */
select a.nombre as articulo,count(c.articulo) as nombre_vecesCompra,sum(a.coste_real) as cost_Total
    from articulo as a join compra c on a.id = c.articulo
    group by a.nombre,coste_real order by nombre_vecesCompra desc;


---Query de validacio
select a.nombre as articulo, a.coste_real ,count(c.articulo) as nombre_vecesCompra,a.coste_real*count(c.articulo) as cost_Total
    from articulo as a join compra c on a.id = c.articulo
    group by a.nombre,coste_real order by nombre_vecesCompra desc;


/* 5.5
 * Mostrar la identificació de les batalles, la durada, la data d'inici i la data de finalització dels
 * clans que la seva descripció no contingui el text "Chuck Norris". Considera només les batalles amb una
 * durada inferior a la durada mitjana de totes les batalles.
 */
(select b.id, b.durada, p.fecha_inicio, p.fecha_fin,c.descripcion
    from clan as c join pelea as p on p.clan = c.id join batalla_clan as bc on p.batalla_clan = bc.id
    join batalla b on p.batalla_clan = b.batalla_clan
    where b.durada < (select avg(durada) from batalla)
    group by b.id, b.durada, p.fecha_inicio, p.fecha_fin, c.descripcion order by  b.durada)
except
select b.id, b.durada, p.fecha_inicio, p.fecha_fin,c.descripcion
    from clan as c join pelea as p on p.clan = c.id join batalla_clan as bc on p.batalla_clan = bc.id
               join batalla b on p.batalla_clan = b.batalla_clan
    where c.descripcion like '%Chuck Norris%'
    group by b.id, b.durada, p.fecha_inicio, p.fecha_fin, c.descripcion order by durada;


--Querys de validación
select c.descripcion from clan as c
except
select c.descripcion from clan as c
    where  c.descripcion like '%Chuck Norris%' or c.descripcion like '%ChuckNorris%' ;

select avg(durada) from batalla;



/* 5.6
 * Enumerar el nom i l'experiència dels jugadors que pertanyen a un clan que té una tecnologia el nom
 * del qual conté la paraula "Militar" i aquests jugadors havien comprat el 2021 més de 5 articles.
 */
select j.nombre, j.experiencia,count(c2.jugador),t.nombre
    from jugador as j join formado f on j.id = f.jugador join clan c on c.id = f.clan
        join clan_modificador cm on c.id = cm.clan join modificador m on cm.modificador = m.nombre
        join tecnologias t on m.nombre = t.nombre join compra c2 on j.id = c2.jugador
    where t.nombre like '%Militar%' and c2.fecha between '2021-01-01' and '2021-12-31'
    group by j.nombre, j.experiencia,t.nombre having count(c2.jugador) > 5;


--Consulta de validacio
select j.nombre, j.experiencia,count(c2.jugador), t.nombre,c.nombre
    from jugador as j join formado f on j.id = f.jugador join clan c on c.id = f.clan
        join clan_modificador cm on c.id = cm.clan join modificador m on cm.modificador = m.nombre
        join tecnologias t on m.nombre = t.nombre join compra c2 on j.id = c2.jugador
    where t.nombre like '%Militar%'and c2.fecha between '2021-01-01' and '2021-12-31'
    group by j.nombre, j.experiencia, t.nombre,c.nombre; --having count(c2.jugador) > 5;


/* 5.7
 * Indiqueu el nom dels jugadors que tenen totes les cartes amb el major valor de dany.
 */
select  j.nombre as jugador
from jugador as j join encuentra e on e.jugador = j.id
join carta c on  e.carta = c.nombre
where c.daño > 200
group by j.nombre having count(j.nombre) > 15;


--Query de validacio1 Algun jugador sin  una de esas cartas.
select j.nombre from jugador as j
except
select  j.nombre as jugador
from jugador as j join encuentra e on e.jugador = j.id
                  join carta c on  e.carta = c.nombre
where c.daño > 200
group by j.nombre having count(j.nombre) > 15;


--Query validacio2
select  j.nombre as jugador, c.nombre as nomCarta, c.daño
from jugador as j join encuentra e on e.jugador = j.id
                  join carta c on  e.carta = c.nombre
where c.daño > 200
group by j.nombre, c.nombre, c.daño order by j.nombre;


--Query validacio3
select  j.nombre as jugador, c.nombre as c, c.daño
from jugador as j join encuentra e on e.jugador = j.id
                  join carta c on  e.carta = c.nombre
where j.nombre like '%ᴢᴇʙᴀʀᴅɪ%'
group by j.nombre, c.nombre;



/* 5.8
 * Retorna el nom de les cartes i el dany que pertanyen a les piles el nom de les quals conté la paraula
 * "Madrid" i van ser creats per jugadors amb experiència superior a 150.000. Considereu només les cartes
 * amb dany superior a 200 i els jugadors que van aconseguir un èxit en el 2021. Enumera el resultat des
 * dels valors més alts del nom de la carta fins als valors més baixos del nom de la carta.
 */

select c.nombre, c.daño
from carta c join compuesto c2 on c.nombre = c2.carta join deck d on d.id = c2.deck
    join jugador j on d.jugador = j.id join desbloquea d2 on j.id = d2.jugador
where d.titulo like '%Madrid%' and j.experiencia > 150000 and d2.fecha between '2021-01-01' and '2021-12-31'
group by c.nombre, c.daño having c.daño > 200 order by c.nombre desc;

--Query de validacion
select c.nombre, c.daño, d.titulo, j.experiencia, d2.fecha
from carta c join compuesto c2 on c.nombre = c2.carta join deck d on d.id = c2.deck
             join jugador j on d.jugador = j.id join desbloquea d2 on j.id = d2.jugador
where d.titulo like '%Madrid%' and j.experiencia > 150000 and d2.fecha between '2021-01-01' and '2021-12-31'
group by c.nombre, c.daño,d.titulo,j.experiencia, d2.fecha having c.daño > 200 order by c.nombre desc;


/* 5.9
 * Enumerar el nom, l’experiència i el nombre de trofeus dels jugadors que no han comprat res. Així, el nom,
 * l'experiència i el número de trofeus dels jugadors que no han enviat cap missatge. Ordenar la sortida de
 * menor a més valor en el nom del jugador.
 */

    (select j.nombre, j.experiencia, j.trofeos
        from jugador as j
    group by j.nombre, j.experiencia, j.trofeos
except
    select j.nombre, j.experiencia, j.trofeos
        from jugador as j join compra c on j.id = c.jugador
    group by j.nombre, j.experiencia, j.trofeos)
union
    (select j.nombre, j.experiencia, j.trofeos
        from jugador as j
    group by j.nombre, j.experiencia, j.trofeos
except
    select j.nombre, j.experiencia, j.trofeos
        from jugador as j join escribe e on j.id = e.id_emisor
    group by j.nombre, j.experiencia, j.trofeos)
    order by nombre asc;



--Consulta de validacio

select j.nombre, j.experiencia, j.trofeos
from jugador as j
group by j.nombre, j.experiencia, j.trofeos;

select j.nombre, j.experiencia, j.trofeos
from jugador as j join compra c on j.id = c.jugador
group by j.nombre, j.experiencia, j.trofeos;

----------------

select j.nombre,j.experiencia,j.trofeos
from jugador as j
group by j.nombre,j.experiencia,j.trofeos;

select j.nombre,j.experiencia,j.trofeos
from jugador as j join escribe e on j.id = e.id_emisor
group by j.nombre,j.experiencia,j.trofeos;



/* 5.10
 * Llistar les cartes comunes que no estan incloses en cap pila i que pertanyen a jugadors amb experiència
 * superior a 200.000. Ordena la sortida amb el nom de la carta.
 */

--Ejecutamos la query y vemos que en el output salen las 4 cartas que hemos creado.
(select c.nombre
 from carta as c join encuentra e on c.nombre = e.carta
                 join jugador j on j.id = e.jugador
 where j.experiencia >200000
 group by c.nombre, c.rareza having c.rareza = 'Common'
 order by c.nombre)
except
(select c.nombre from carta as c join compuesto c2 on c.nombre = c2.carta
 group by c.nombre order by nombre);



/* 5.11
 * Llistar el nom dels jugadors que han sol·licitat amics, però no han estat sol·licitats com a amics.
 */

select j.nombre
from jugador as j join amigo a on j.id = a.id_jugador_emisor
group by j.nombre
except
select j.nombre
from jugador as j join amigo a2 on j.id = a2.id_jugador_receptor
group by j.nombre;


select j.nombre
from jugador as j join amigo a on j.id = a.id_jugador_emisor
group by j.nombre
intersect
select j.nombre
from jugador as j join amigo a2 on j.id = a2.id_jugador_receptor
group by j.nombre;




/* 5.12
 * Enumerar el nom dels jugadors i el nombre d'articles comprats que tenen un cost superior al cost mitjà
 * de tots els articles. Ordenar el resultat de menor a major valor del nombre de comandes.
 */
select j.nombre, count(c.id)
    from jugador as j join compra c on j.id = c.jugador
    join articulo a on a.id = c.articulo
where a.coste_real > (select avg(coste_real) from articulo)
group by j.nombre order by count(j.nombre) asc;


--VAlidacio

select avg(coste_real) from articulo;

select j.nombre, count(c.id), a.coste_real
from jugador as j join compra c on j.id = c.jugador
                  join articulo a on a.id = c.articulo
where a.coste_real > (select avg(coste_real) from articulo)
group by j.nombre,a.coste_real
order by count(j.nombre) asc;

/* 5.13
 * Poseu a zero els valors d'or i gemmes als jugadors que no han enviat cap missatge o que han enviat el
 * mateix nombre de missatges que el jugador que més missatges ha enviat.
 */

select *
from jugador
where jugador.id = '#22UCV0000';

update jugador
set oro   = 0,
    gemas = 0
where jugador.id in (
    select t.id
    from (
             /* Selects players with number of messages sended to clans */
             select jugador.id, jugador.nombre, count(emisor) as num_mensajes_enviados
             from clan
                      join mensaje_clan mc on clan.id = mc.receptor
                      join jugador on mc.emisor = jugador.id
             group by jugador.id, jugador.nombre
             union all
             /* Selects players with number of messages sended to players */
             select jugador.id, jugador.nombre, count(id_mensaje) as num_mensajes_enviados_a_clanes
             from jugador
                      join escribe on jugador.id = escribe.id_emisor
                      join mensaje on escribe.id_mensaje = mensaje.id
             group by jugador.id
         ) t
    group by t.nombre, t.id
    having sum(num_mensajes_enviados) = (
        select MAX(total_mensajes_enviados)
        from (
                 /* Devuelve una lista con el total de mensajes enviados por jugadores a jugadores y jugadores a clanes */
                 select t.id, t.nombre, SUM(num_mensajes_enviados) as total_mensajes_enviados
                 from (
                          /* Selects players with number of messages sended to clans */
                          select jugador.id, jugador.nombre, count(emisor) as num_mensajes_enviados
                          from clan
                                   join mensaje_clan mc on clan.id = mc.receptor
                                   join jugador on mc.emisor = jugador.id
                          group by jugador.id, jugador.nombre
                          union all
                          /* Selects players with number of messages sended to players */
                          select jugador.id, jugador.nombre, count(id_mensaje) as num_mensajes_enviados
                          from jugador
                                   join escribe on jugador.id = escribe.id_emisor
                                   join mensaje on escribe.id_mensaje = mensaje.id
                          group by jugador.id
                      ) t
                 group by t.nombre, t.id
             ) t2
    ))
   or jugador.id not in (
    /* Selects players with number of messages sended to a clan */
    select jugador.id
    from clan
             join mensaje_clan mc on clan.id = mc.receptor
             join jugador on mc.emisor = jugador.id
    group by jugador.id, jugador.nombre
    union all
    /* Selects players with number of messages sended to players */
    select jugador.id
    from jugador
             join escribe on jugador.id = escribe.id_emisor
             join mensaje on escribe.id_mensaje = mensaje.id
    group by jugador.id
);

select *
from jugador
where jugador.id = '#22UCV0000';

delete from jugador
where jugador.id = '#22UCV0000';