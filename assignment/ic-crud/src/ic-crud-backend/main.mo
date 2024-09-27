import Array "mo:base/Array";
import Text "mo:base/Text";
import Nat "mo:base/Nat";

actor TodoList {
    
    // Define the Todo type
    type Todo = {
        id: Nat;
        description: Text;
        completed: Bool;
    };

    // State to store todos
    stable var todos: [Todo] = [];
    stable var nextId: Nat = 0;

    // Create: Add a new todo
    public func addTodo(description: Text) : async Nat {
        let id = nextId;
        nextId += 1;
        let newTodo: Todo = {
            id = id;
            description = description;
            completed = false;
        };
        todos := Array.append(todos, [newTodo]);
        id
    };

    // Read: Get all todos
    public query func getAllTodos() : async [Todo] {
        todos
    };

    // Read: Get a specific todo by id
    public query func getTodo(id: Nat) : async ?Todo {
        Array.find(todos, func (todo: Todo) : Bool { todo.id == id })
    };

    // Update: Update a todo's description
    public func updateTodoDescription(id: Nat, newDescription: Text) : async Bool {
        todos := Array.map(todos, func (todo: Todo) : Todo {
            if (todo.id == id) {
                return {
                    id = todo.id;
                    description = newDescription;
                    completed = todo.completed;
                };
            };
            todo
        });
        true
    };

    // Update: Toggle a todo's completed status
    public func toggleTodoStatus(id: Nat) : async Bool {
        todos := Array.map(todos, func (todo: Todo) : Todo {
            if (todo.id == id) {
                return {
                    id = todo.id;
                    description = todo.description;
                    completed = not todo.completed;
                };
            };
            todo
        });
        true
    };

    // Delete: Remove a todo by id
    public func deleteTodo(id: Nat) : async Bool {
        let initialLength = todos.size();
        todos := Array.filter(todos, func (todo: Todo) : Bool { todo.id != id });
        todos.size() < initialLength
    };
};