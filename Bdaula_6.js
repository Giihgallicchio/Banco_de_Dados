db('db_turmad').collection('actor').find(
    {actor_id: 2}
);
 
db('db_turmad').collection('actor').find(
  {$or:  [{actor_id: {$gte:5}, first_name: 'JULIA'}]}
);
 
db('db_turmad').collection('actor').find(
    {$or:  [{actor_id: {$gte:5}, first_name: 'JULIA'}]}
  );
 
db('db_turmad').collection('actor').find(
    {actor_id: 5}
);
 
db('db_turmad').collection('actor').updateOne(
    { actor_id: 5},
    { $set: { first_name: 'Romulo', last_name: 'Maia' } }
);


db('db_turmad').collection('actor').find(
    {first_name: /.*RE.*/ },
);


db('db_turmad').collection('actor').find(
    { first_name: /.*RE.*/ },
).sort({ first_name: 1 });


db('db_turmad').collection('actor').find(
    { first_name: /.*RE.*/ },
).sort({ first_name: -1 });


db('db_turmad').collection('actor').find().sort({ last_name: 1 });


db('db_turmad').collection('actor').find(
    { first_name: /.*RE.*/ },
).count();


db('db_turmad').collection('actor').deleteOne(
    { actor_id: 5}
);


db('db_turmad').collection('actor').find();



