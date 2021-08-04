pub contract Hello {
  pub event IssuedGreeting(greeting: String)
  pub event FooEvent(x: Int, y: Int)

  pub fun sayHi(to name: String): String {
    let greeting = "Hi, ".concat(name)

    emit IssuedGreeting(greeting: greeting)
    emit FooEvent(x: 1, y: 2)
    return greeting
  }
}