interface Dog {
  name: string
  age: number
}

let dogs: Array<Dog> = [
  {
    name: 'Roger',
    age: 8,
  },
  {
    name: 'Syd',
    age: 7,
  },
]

// GET request '/dogs'
export const getDogs = (ctx: any) => {
  ctx.response.body = dogs
}

// GET request '/dogs/:name'
export const getDog = (ctx: any) => {
  const dog = dogs.filter((dog) => dog.name === ctx.params.name)
  if (dog.length) {
    ctx.response.status = 200
    ctx.response.body = dog[0]
    return
  }

  ctx.response.status = 400
  ctx.response.body = { msg: `Cannot find dog ${ctx.params.name}` }
}

// POST request '/dogs'
export const addDog = async (ctx: any) => {
  const body = await ctx.request.body({ type: 'json' })
  const dog: Dog = {"name": "Tina", "age": 4 }
  // const dog: Dog = body.value
  let n = dogs.push(dog)

  ctx.response.status = 200
  ctx.response.body = { msg: 'OK' }
}

// PUT request '/dogs/:name'
export const updateDog = async (ctx: any) => {
  const temp = dogs.filter((dog) => dog.name === ctx.params.name)
  const body = await ctx.request.body({ type: 'json' })
  // const { age }: { age: number } = body.value
  const age = 99

  if (temp.length) {
    temp[0].age = age
    ctx.response.status = 200
    ctx.response.body = { msg: 'OK' }
    return
  }

  ctx.response.status = 400
  ctx.response.body = { msg: `Cannot find dog ${ctx.params.name}` }
}

// DELETE request '/dogs/:name'
export const removeDog = (ctx: any) => {
  const lengthBefore = dogs.length
  dogs = dogs.filter((dog) => dog.name !== ctx.params.name)

  if (dogs.length === lengthBefore) {
    ctx.response.status = 400
    ctx.response.body = { msg: `Cannot find dog ${ctx.params.name}` }
    return
  }

  ctx.response.status = 200
  ctx.response.body = { msg: 'OK' }
}
