# needed to get defdatabase and other macros
use Amnesia
use Timex

# defines a database called Database, it's basically a defmodule with
# some additional magic
defdatabase Database do
  # this is just a forward declaration of the table, otherwise you'd have
  # to fully scope User.read in Message functions
  deftable Sensor
  deftable Node

  # this defines a table with an user_id key and a content attribute, and
  # makes the table a bag; tables are basically records with a bunch of helpers
  deftable Value, [{:id, autoincrement}, :sensor_id, :node_id, :mysensors_node_id, :mysensors_sensor_id, :type, :content, :created], type: :bag do
    # this isn't required, but it's always nice to spec things
    @type t :: %Value{id: integer, sensor_id: integer, node_id: integer, mysensors_sensor_id: integer, mysensors_node_id: integer, type: String.t, content: String.t, created: DateTime.t }

    # this defines a helper function to fetch the user from a Message record
    def sensor(self) do
      Sensor.read(self.sensor_id)
    end

    def sensor!(self) do
      Sensor.read!(self.sensor_id)
    end

    # this does the same, but uses dirty operations
    def node!(self) do
      Node.read!(self.node_id)
    end

    def node(self) do
      Node.read(self.node_id)
    end
  end

  # this defines a table with other attributes as ordered set, and defines an
  # additional index as email, this improves lookup operations
  deftable Sensor, [{ :id, autoincrement }, :mysensors_node_id, :mysensors_sensor_id, :node_id, :name, :display_name, :last_seen, :created], type: :bag do
    # again not needed, but nice to have
    @type t :: %Sensor{id: integer, mysensors_node_id: integer, mysensors_sensor_id: integer, node_id: integer, name: String.t, display_name: String.t, last_seen: DateTime.t, created: DateTime.t}

    # this is a helper function to add a message to the user, using write
    # on the created records makes it write to the mnesia table
    def add_value(self, type, content) do
      %Value{mysensors_sensor_id: self.mysensors_sensor_id, mysensors_node_id: self.mysensors_node_id, node_id: self.node_id, sensor_id: self.id, type: type, content: content, created: DateTime.now} |> Value.write
    end

    # like above, but again with dirty operations, the bang methods are used
    # thorough amnesia to be the dirty counterparts of the bang-less functions
    def add_value!(self, type, content) do
      %Value{mysensors_sensor_id: self.mysensors_sensor_id, mysensors_node_id: self.mysensors_node_id, node_id: self.node_id, sensor_id: self.id, type: type, content: content, created: DateTime.now} |> Value.write!
    end

    # this is a helper to fetch all messages for the user
    def values(self) do
      Value.read(self.id)
    end

    # like above, but with dirty operations
    def values!(self) do
      Value.read!(self.id)
    end

    def node!(self) do
      Node.read!(self.node_id)
    end

    def node(self) do
      Node.read(self.node_id)
    end
  end

  deftable Node, [{ :id, autoincrement }, :mysensors_node_id, :name, :display_name, :last_seen, :created], type: :bag do
    # again not needed, but nice to have
    @type t :: %Sensor{id: integer, mysensors_node_id: integer, node_id: integer, name: String.t, display_name: String.t, last_seen: DateTime.t, created: DateTime.t}

    def create_node(mysensors_node_id, name, display_name) do
      %Node{mysensors_node_id: mysensors_node_id, name: name, display_name: display_name, last_seen: DateTime.now, created: DateTime.now} |> Node.write
    end

    def create_node!(mysensors_node_id, name, display_name) do
      %Node{mysensors_node_id: mysensors_node_id, name: name, display_name: display_name, last_seen: DateTime.now, created: DateTime.now} |> Node.write!
    end

    def add_sensor(self, mysensors_sensor_id, name, display_name) do
      %Sensor{mysensors_node_id: self.mysensors_node_id, mysensors_sensor_id: mysensors_sensor_id, node_id: self.id, name: name, display_name: display_name, last_seen: DateTime.now, created: DateTime.now} |> Sensor.write
    end

    def add_sensor!(self, mysensors_sensor_id, name, display_name) do
      %Sensor{mysensors_node_id: self.mysensors_node_id, mysensors_sensor_id: mysensors_sensor_id, node_id: self.id, name: name, display_name: display_name, last_seen: DateTime.now, created: DateTime.now} |> Sensor.write!
    end

    def sensors(self) do
      Sensor.read(self.id)
    end

    def sensors!(self) do
      Sensor.read(self.id)
    end

  end
end
