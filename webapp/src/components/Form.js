import React, { useState } from 'react'
import Button from 'react-bootstrap/Button'

function Form (props) {
  const [name, setName] = useState('')

  function handleChnage (e) {
    setName(e.target.value)
  }

  function handleSubmit (e) {
    e.preventDefault()
    props.addTask(name)
  }

  return (
    <form onSubmit={handleSubmit}>
      <h2 className="label-wrapper">
        <label htmlFor="new-todo-input">
          Manage Your To-do
        </label>
      </h2>
      <input
        type="text"
        id="new-todo-input"
        className="input input__lg"
        name="text"
        autoComplete="off"
        value={name}
        onChange={handleChnage}
      />
      <Button type="submit" variant="outline-primary" >
        Add
      </Button>
    </form>
  )
}

export default Form
