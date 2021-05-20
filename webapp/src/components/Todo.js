import React, { useState } from 'react'
import ButtonGroup from 'react-bootstrap/ButtonGroup'
import Button from 'react-bootstrap/Button'
import ListGroup from 'react-bootstrap/ListGroup'

export default function Todo (props) {
  const [isEditing, setEditing] = useState(false)
  const [newName, setNewName] = useState('')

  function handleChange (e) {
    setNewName(e.target.value)
  }

		
  function handleSubmit (e) {
    e.preventDefault()
    props.editTask(props.id, newName)
    setNewName('')
    setEditing(false)
  }

  const editingTemplate = (
    <form className="stack-small" onSubmit={handleSubmit}>
      <div className="form-group">
        <label className="todo-label" htmlFor={props.id}>
          New title for {props.title}
				</label>
				<input id={props.id} className="todo-text" type="text" onChange={handleChange} />
			</div>
				<ButtonGroup aria-label="Editing Buttons" size="sm">
				<Button variant="outline-warning" onClick={() => setEditing(false)}>
					Cancel
				</Button>
				<Button variant="outline-primary">
					Save
				</Button>
			</ButtonGroup>
		</form>
  )
  const viewTemplate = (
		<div className="stack-small">
				<input
					id={props.id}
					type="checkbox"
					defaultChecked={props.isComplete}
					onChange={() => props.toggleTaskCompleted(props.id)}
				/>
				<label className="todo-label" htmlFor={props.id}>
					{props.title}
				</label>
			<ButtonGroup aria-label="Editing Buttons" size="sm">
				<Button
					variant="outline-secondary"
					size="sm"
					onClick={() => setEditing(true)}>
					Edit
				</Button>
				<Button
					variant="outline-danger"
					size="sm"
					onClick={() => props.deleteTask(props.id)}
				>
					Delete
				</Button>
			</ButtonGroup>
		</div>
  )

  return (

		<ListGroup.Item>{isEditing ? editingTemplate : viewTemplate}</ListGroup.Item>
	)
}
