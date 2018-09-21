# Tasks (API)

## `POST /api/users/me/tasks`

Create a new task owned by current user.

Parameters:

| Name             | Type   | Description             | Optional |
|------------------|--------|-------------------------|----------|
| task             | object |                         |          |
| task.label       | string | Task's label            |          |
| task.planned\_at | number | Task's due date         | yes      |
| task.project\_id | number | Task's project relation | yes      |

Notes:

- if `planned_at` is provided, `state` is always set to `planned` and
  `planned_count` to 1
- otherwise, if `project_id` matches with a not started project, `state` is set
  to `newed`
- in other situations (project is started or no `project_id` is provided),
  task's state is set to `started`

Result format:

| Name                                            | Type   | Description                              | Optional |
|-------------------------------------------------|--------|------------------------------------------|----------|
| data                                            | object |                                          |          |
| data.type                                       | string | Type of returned data (always `task`)    |          |
| data.id                                         | number | Task's identifier                        |          |
| data.attributes                                 | object |                                          |          |
| data.attributes.label                           | string | Task's label                             |          |
| data.attributes.order                           | number | Task's order                             |          |
| data.attributes.plannedCount                    | number | Number of times task has been planned    |          |
| data.attributes.state                           | string | Task's state                             |          |
| data.attributes.startedAt                       | date   | Date when task has been created          | yes      |
| data.attributes.plannedAt                       | date   | Task's due date                          | yes      |
| data.attributes.finishedAt                      | date   | Date when task has been finished         | yes      |
| data.attributes.abandonedAt                     | date   | Date when task has been abandoned        | yes      |
| data.attributes.createdAt                       | date   | Date when task has been created          |          |
| data.attributes.updatedAt                       | date   | Date when task has been updated          |          |
| data.relationships                              | object |                                          |          |
| data.relationships.user                         | object | Related user reference                   |          |
| data.relationships.user.data                    | object |                                          |          |
| data.relationships.user.data.type               | string | Type of data (always `user`)             |          |
| data.relationships.user.data.id                 | number | User's identifier                        |          |
| data.relationships.project                      | object | Related project reference                |          |
| data.relationships.project.data                 | object |                                          | yes      |
| data.relationships.project.data.type            | string | Type of data (always `project`)          |          |
| data.relationships.project.data.id              | number | Project's identifier                     |          |

**Important note :** this output may evolve quite soon!

Specific errors: none.

Example:

```console
$ curl -H "Content-Type: application/json" \
       -H "Authorization: <token>" \
       -X POST \
       -d '{"task": {"label": "Buy good coffee", "project_id": 42}}' \
       https://lessy.io/api/users/me/tasks
```

```json
{
  "data": {
    "type": "task",
    "id": 23,
    "attributes": {
      "label": "Buy good coffee",
      "order": 2,
      "plannedCount": 0,
      "state": "started",
      "startedAt": "2017-10-08T09:26:35.000Z",
      "plannedAt": null,
      "finishedAt": null,
      "abandonedAt": null,
      "createdAt": "2017-10-08T09:26:35.000Z",
      "updatedAt": "2017-10-08T09:26:35.000Z"
    },
    "relationships": {
      "user": {
        "data": { "type": "user", "id": 1 }
      },
      "project": {
        "data": { "type": "project", "id": 42 }
      }
    }
  }
}
```

## `GET /api/users/me/tasks`

List tasks owned by current user. This endpoint is paginated and return a
maximum of 50 items per page.

**This endpoint requires an `Authorization` header but NOT that user accepted
terms of service.**

Parameters:

| Name      | Type   | Description                       | Optional |
|-----------|--------|-----------------------------------|----------|
| page      | number | Tasks' page to fetch (default: 1) | yes      |

Note: abandoned tasks are never returned. Also, it does not return tasks
finished more than 2 weeks ago.

Result format:

| Name                                              | Type   | Description                              | Optional |
|---------------------------------------------------|--------|------------------------------------------|----------|
| data                                              | array  |                                          |          |
| data[].type                                       | string | Type of returned data (always `task`)    |          |
| data[].id                                         | number | Task's identifier                        |          |
| data[].attributes                                 | object |                                          |          |
| data[].attributes.label                           | string | Task's label                             |          |
| data[].attributes.order                           | number | Task's order                             |          |
| data[].attributes.plannedCount                    | number | Number of times task has been planned    |          |
| data[].attributes.state                           | string | Task's state                             |          |
| data[].attributes.startedAt                       | date   | Date when task has been created          | yes      |
| data[].attributes.plannedAt                       | date   | Task's due date                          | yes      |
| data[].attributes.finishedAt                      | date   | Date when task has been finished         | yes      |
| data[].attributes.abandonedAt                     | date   | Date when task has been abandoned        | yes      |
| data[].attributes.createdAt                       | date   | Date when task has been created          |          |
| data[].attributes.updatedAt                       | date   | Date when task has been updated          |          |
| data[].relationships                              | object |                                          |          |
| data[].relationships.user                         | object | Related user reference                   |          |
| data[].relationships.user.data                    | object |                                          |          |
| data[].relationships.user.data.type               | string | Type of data (always `user`)             |          |
| data[].relationships.user.data.id                 | number | User's identifier                        |          |
| data[].relationships.project                      | object | Related project reference                |          |
| data[].relationships.project.data                 | object |                                          | yes      |
| data[].relationships.project.data.type            | string | Type of data (always `project`)          |          |
| data[].relationships.project.data.id              | number | Project's identifier                     |          |
| links                                             | object |                                          |          |
| links.first                                       | string | Link to the first page of pagination     |          |
| links.last                                        | string | Link to the last page of pagination      |          |
| links.prev                                        | string | Link to the previous page of pagination  | yes      |
| links.next                                        | string | Link to the next page of pagination      | yes      |

**Important note :** this output may evolve quite soon!

Specific errors: none.

Example:

```console
$ curl -H "Authorization: <token>" https://lessy.io/api/users/me/tasks
```

```json
{
  "data": [
    {
      "type": "task",
      "id": 19,
      "attributes": {
        "label": "Ask Audrey to bring cherry pie",
        "order": 1,
        "plannedCount": 1,
        "state": "planned",
        "startedAt": "2017-01-20T00:00:00.000Z",
        "plannedAt": "2017-10-08T09:34:46.000Z",
        "finishedAt": null,
        "abandonedAt": null,
        "createdAt": "2017-01-20T00:00:00.000Z",
        "updatedAt": "2017-10-08T09:34:46.000Z"
      },
      "relationships": {
        "user": {
          "data": { "type": "user", "id": 1 }
        },
        "project": {
          "data": null
        }
      }
    },
    {
      "type": "task",
      "id": 23,
      "attributes": {
        "label": "Buy good coffee",
        "order": 2,
        "plannedCount": 0,
        "state": "started",
        "startedAt": "2017-10-08T09:26:35.000Z",
        "plannedAt": null,
        "finishedAt": null,
        "abandonedAt": null,
        "createdAt": "2017-10-08T09:26:35.000Z",
        "updatedAt": "2017-10-08T09:26:35.000Z"
      },
      "relationships": {
        "user": {
          "data": { "type": "user", "id": 1 }
        },
        "project": {
          "data": { "type": "project", "id": 42 }
        }
      }
    }
  ],
  "links": {
    "first": "https://lessy.io/api/users/me/tasks?page=1",
    "last": "https://lessy.io/api/users/me/tasks?page=1"
  }
}
```

## `GET /api/tasks/:id`

Return a given task.

Parameters: none.

Result format:

| Name                                            | Type   | Description                              | Optional |
|-------------------------------------------------|--------|------------------------------------------|----------|
| data                                            | object |                                          |          |
| data.type                                       | string | Type of returned data (always `task`)    |          |
| data.id                                         | number | Task's identifier                        |          |
| data.attributes                                 | object |                                          |          |
| data.attributes.label                           | string | Task's label                             |          |
| data.attributes.order                           | number | Task's order                             |          |
| data.attributes.plannedCount                    | number | Number of times task has been planned    |          |
| data.attributes.state                           | string | Task's state                             |          |
| data.attributes.startedAt                       | date   | Date when task has been created          | yes      |
| data.attributes.plannedAt                       | date   | Task's due date                          | yes      |
| data.attributes.finishedAt                      | date   | Date when task has been finished         | yes      |
| data.attributes.abandonedAt                     | date   | Date when task has been abandoned        | yes      |
| data.attributes.createdAt                       | date   | Date when task has been created          |          |
| data.attributes.updatedAt                       | date   | Date when task has been updated          |          |
| data.relationships                              | object |                                          |          |
| data.relationships.user                         | object | Related user reference                   |          |
| data.relationships.user.data                    | object |                                          |          |
| data.relationships.user.data.type               | string | Type of data (always `user`)             |          |
| data.relationships.user.data.id                 | number | User's identifier                        |          |
| data.relationships.project                      | object | Related project reference                |          |
| data.relationships.project.data                 | object |                                          | yes      |
| data.relationships.project.data.type            | string | Type of data (always `project`)          |          |
| data.relationships.project.data.id              | number | Project's identifier                     |          |

**Important note :** this output may evolve quite soon!

Specific errors: none.

Example:

```console
$ curl -H "Authorization: <token>" https://lessy.io/api/tasks/23
```

```json
{
  "data": {
    "type": "task",
    "id": 23,
    "attributes": {
      "label": "Buy DAMN FINE coffee",
      "order": 2,
      "plannedCount": 0,
      "state": "started",
      "startedAt": "2017-10-08T09:26:35.000Z",
      "plannedAt": null,
      "finishedAt": null,
      "abandonedAt": null,
      "createdAt": "2017-10-08T09:26:35.000Z",
      "updatedAt": "2017-10-08T09:26:35.000Z"
    },
    "relationships": {
      "user": {
        "data": { "type": "user", "id": 1 }
      },
      "project": {
        "data": { "type": "project", "id": 42 }
      }
    }
  }
}
```

## `PATCH /api/tasks/:id`

Update a given task.

Parameters:

| Name             | Type   | Description             | Optional |
|------------------|--------|-------------------------|----------|
| task             | object |                         |          |
| task.label       | string | Task's label            | yes      |
| task.project\_id | number | Task's project relation | yes      |

Note: depending on the given project, task's state can change:

- if task's state was `newed`, it is changed to `started` if no project is
  given or if project is `started`
- if task's state was `started`, it is changed to `newed` if given project is
  NOT `started`
- state doesn't change in any other configuration

Result format:

| Name                                            | Type   | Description                              | Optional |
|-------------------------------------------------|--------|------------------------------------------|----------|
| data                                            | object |                                          |          |
| data.type                                       | string | Type of returned data (always `task`)    |          |
| data.id                                         | number | Task's identifier                        |          |
| data.attributes                                 | object |                                          |          |
| data.attributes.label                           | string | Task's label                             |          |
| data.attributes.order                           | number | Task's order                             |          |
| data.attributes.plannedCount                    | number | Number of times task has been planned    |          |
| data.attributes.state                           | string | Task's state                             |          |
| data.attributes.startedAt                       | date   | Date when task has been created          | yes      |
| data.attributes.plannedAt                       | date   | Task's due date                          | yes      |
| data.attributes.finishedAt                      | date   | Date when task has been finished         | yes      |
| data.attributes.abandonedAt                     | date   | Date when task has been abandoned        | yes      |
| data.attributes.createdAt                       | date   | Date when task has been created          |          |
| data.attributes.updatedAt                       | date   | Date when task has been updated          |          |
| data.relationships                              | object |                                          |          |
| data.relationships.user                         | object | Related user reference                   |          |
| data.relationships.user.data                    | object |                                          |          |
| data.relationships.user.data.type               | string | Type of data (always `user`)             |          |
| data.relationships.user.data.id                 | number | User's identifier                        |          |
| data.relationships.project                      | object | Related project reference                |          |
| data.relationships.project.data                 | object |                                          | yes      |
| data.relationships.project.data.type            | string | Type of data (always `project`)          |          |
| data.relationships.project.data.id              | number | Project's identifier                     |          |

**Important note :** this output may evolve quite soon!

Specific errors: none.

Example:

```console
$ curl -H "Content-Type: application/json" \
       -H "Authorization: <token>" \
       -X PATCH \
       -d '{"task": {"label": "Buy DAMN FINE coffee"}}' \
       https://lessy.io/api/tasks/23
```

```json
{
  "data": {
    "type": "task",
    "id": 23,
    "attributes": {
      "label": "Buy DAMN FINE coffee",
      "order": 2,
      "plannedCount": 0,
      "state": "started",
      "startedAt": "2017-10-08T09:26:35.000Z",
      "plannedAt": null,
      "finishedAt": null,
      "abandonedAt": null,
      "createdAt": "2017-10-08T09:26:35.000Z",
      "updatedAt": "2017-10-08T09:56:35.000Z"
    },
    "relationships": {
      "user": {
        "data": { "type": "user", "id": 1 }
      },
      "project": {
        "data": { "type": "project", "id": 42 }
      }
    }
  }
}
```

## `PUT /api/tasks/:id/state`

Update a given task's state.

Parameters:

| Name             | Type   | Description             | Optional |
|------------------|--------|-------------------------|----------|
| task             | object |                         |          |
| task.state       | string | Task's state            |          |

Note: possible values of `state` are `newed`, `started`, `planned`, `finished`
or `abandoned`. Please refer to [task creation notes](#post-apiusersmetasks) to
know more about initial state.

State follow this state's machine:

```ascii
+------------------------------------------------------------------------------+
|                                              plan          replan            |
|           +--------------------------------------------+  +-----+            |
|           |                                            |  |     |            |
|  +--------+---+    start    +------------+   plan    +-v--+-----v-+          |
|  | newed      +-------------> started    +-----------> planned    +-+        |
|  +--------^---+             +-----+------+           +----+----^--+ |        |
|           |                       |                       |    |    |        |
|           +-----------------------+-----------------------+    |    |finish  |
|                   cancel                                       |    |        |
+---------------------------+------------------------------------|----|--------+
                            |                                    |    |
                    abandon |                             replan |    |
                            |                                    |    |
                    +-------v----+                             +-+----v-----+
                    | abandoned  |                             | finished   |
                    +------------+                             +------------+
```

Also, following rules apply:

- `started_at` is set to now on `start` and `plan` actions if not already set
- `planned_at` is set to now and `planned_count` is incremented by one on
  `plan` and `replan` actions
- `finished_at` is set to nil on `replan` and to now on `finish`
- `started_at` and `planned_at` are set to nil on `cancel`
- `abandoned_at` is set to now on `abandon` action

Result format:

| Name                                            | Type   | Description                              | Optional |
|-------------------------------------------------|--------|------------------------------------------|----------|
| data                                            | object |                                          |          |
| data.type                                       | string | Type of returned data (always `task`)    |          |
| data.id                                         | number | Task's identifier                        |          |
| data.attributes                                 | object |                                          |          |
| data.attributes.label                           | string | Task's label                             |          |
| data.attributes.order                           | number | Task's order                             |          |
| data.attributes.plannedCount                    | number | Number of times task has been planned    |          |
| data.attributes.state                           | string | Task's state                             |          |
| data.attributes.startedAt                       | date   | Date when task has been created          | yes      |
| data.attributes.plannedAt                       | date   | Task's due date                          | yes      |
| data.attributes.finishedAt                      | date   | Date when task has been finished         | yes      |
| data.attributes.abandonedAt                     | date   | Date when task has been abandoned        | yes      |
| data.attributes.createdAt                       | date   | Date when task has been created          |          |
| data.attributes.updatedAt                       | date   | Date when task has been updated          |          |
| data.relationships                              | object |                                          |          |
| data.relationships.user                         | object | Related user reference                   |          |
| data.relationships.user.data                    | object |                                          |          |
| data.relationships.user.data.type               | string | Type of data (always `user`)             |          |
| data.relationships.user.data.id                 | number | User's identifier                        |          |
| data.relationships.project                      | object | Related project reference                |          |
| data.relationships.project.data                 | object |                                          | yes      |
| data.relationships.project.data.type            | string | Type of data (always `project`)          |          |
| data.relationships.project.data.id              | number | Project's identifier                     |          |

**Important note :** this output may evolve quite soon!

Specific errors:

| Code                            | Description                                                     |
|---------------------------------|-----------------------------------------------------------------|
| must\_be\_set                   | Attribute given in path must be set                             |
| cannot\_be\_set                 | Attribute given in path cannot be set                           |
| invalid\_transition             | Task cannot reach given state                                   |

Example:

```console
$ curl -H "Content-Type: application/json" \
       -H "Authorization: <token>" \
       -X PUT \
       -d '{"task": {"state": "planned"}}' \
       https://lessy.io/api/tasks/23/state
```

```json
{
  "data": {
    "type": "task",
    "id": 23,
    "attributes": {
      "label": "Buy DAMN FINE coffee",
      "order": 2,
      "plannedCount": 1,
      "state": "planned",
      "startedAt": "2017-10-08T09:26:35.000Z",
      "plannedAt": "2017-10-08T10:03:22.000Z",
      "finishedAt": null,
      "abandonedAt": null,
      "createdAt": "2017-10-08T09:26:35.000Z",
      "updatedAt": "2017-10-08T10:26:35.000Z"
    },
    "relationships": {
      "user": {
        "data": { "type": "user", "id": 1 }
      },
      "project": {
        "data": { "type": "project", "id": 42 }
      }
    }
  }
}
```

## `PUT /api/tasks/:id/order`

Update a given task's order.

Parameters:

| Name             | Type   | Description             | Optional |
|------------------|--------|-------------------------|----------|
| task             | object |                         |          |
| task.order       | number | Task's order            |          |

Note: changing order of a task may change other tasks' order and so all
impacted tasks are returned.

Result format:

| Name                                              | Type   | Description                              | Optional |
|---------------------------------------------------|--------|------------------------------------------|----------|
| data                                              | array  |                                          |          |
| data[].type                                       | string | Type of returned data (always `task`)    |          |
| data[].id                                         | number | Task's identifier                        |          |
| data[].attributes                                 | object |                                          |          |
| data[].attributes.order                           | number | Task's order                             |          |

Specific errors: none.

Example:

```console
$ curl -H "Content-Type: application/json" \
       -H "Authorization: <token>" \
       -X PUT \
       -d '{"task": {"order": 1}}' \
       https://lessy.io/api/tasks/23/order
```

```json
{
  "data": [
    {
      "type": "task",
      "id": 19,
      "attributes": { "order": 2 }
    },
    {
      "type": "task",
      "id": 23,
      "attributes": { "order": 1 }
    }
  ]
}
```
