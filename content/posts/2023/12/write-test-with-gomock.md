---
title: "使用 gomock 寫測試"
date: 2023-12-31T22:36:02+08:00
tags: [go, test]
---

gomock 原本是 golang 官方維護的套件，不過因為有一段時間沒有在維護了，在 2023 年 6 月時就改由 uber 團隊接手維護了。

- 停止維護: https://github.com/golang/mock
- 目前有在維護: https://github.com/uber-go/mock

## 安裝工具

安裝 `mockgen` 工具，`gomock` 套件

```bash
go install go.uber.org/mock/mockgen@latest
go get go.uber.org/mock/gomock
```

## 如何使用

## 寫好 interface 宣告

寫個簡單的範例，一個 user struct 以及一個 UserRepository interface

`user/user.go`
```go
package user

type User struct {
	ID   uint
	Name string
}

type UserRepository interface {
	Get(id int) (User, error)
	Save(user User) error
}
```



## 使用 mockgen 產生 mock struct

使用 mockgen 指令
- `-source`: 指定寫 interface 的檔案
- `-destination`: 指定產生檔案的位置

```bash
mockgen -source=user/user.go -destination=mock/user.go
```

產生的 `mock/user.go`

```go
// Code generated by MockGen. DO NOT EDIT.
// Source: user/user.go
//
// Generated by this command:
//
//	mockgen -source=user/user.go -destination=mock/user.go
//

// Package mock_user is a generated GoMock package.
package mock_user

...

// MockUserRepository is a mock of UserRepository interface.
type MockUserRepository struct {
	ctrl     *gomock.Controller
	recorder *MockUserRepositoryMockRecorder
}
...
```

## 在測試程式中使用 mock struct

```go
func TestUserRepository(t *testing.T) {
	ctrl := gomock.NewController(t)
	defer ctrl.Finish()

	repo := mock_user.NewMockUserRepository(ctrl)

	t.Run("Mock Get(1)", func(t *testing.T) {
		// 預期會傳入 1 到 Get()，不符合預期會 fail
		// 回傳 user.User{ID: 1, Name: "John"}
		repo.EXPECT().Get(1).Return(user.User{ID: 1, Name: "John"}, nil)

		// 使用模擬的 repo 執行 user.RunGet()
		user.RunGet(repo)
	})

	t.Run("Stub Get(1) and Get(2)", func(t *testing.T) {
		// 當傳入 2 到 Get() 時，回傳 user.User{ID: 2, Name: "Tom"}
		repo.EXPECT().Get(2).Return(user.User{ID: 2, Name: "Tom"}, nil).AnyTimes()
		// 當傳入 1 到 Get() 時，回傳 user.User{ID: 1, Name: "John"}
		repo.EXPECT().Get(1).Return(user.User{ID: 1, Name: "John"}, nil).AnyTimes()

		// 使用模擬的 repo 執行 user.RunGet()
		user.RunGet(repo)
	})

    t.Run("Stub Save(any)", func(t *testing.T) {
		// 當傳入任何值到 Save() 時，回傳 nil
		repo.EXPECT().Save(gomock.Any()).DoAndReturn(
			func(user user.User) error {
				if user.Name == "" {
					return errors.New("Name is empty")
				}
				return nil
			},
		).AnyTimes()

		// 使用模擬的 repo 執行 user.RunSave()
		user.RunSave(repo)
	})
}
```

第一個測試案例，預期 mock repository 的 Get() function 會接到 1 的傳入值，並回傳指定 User，如果我們寫的程式不如預期傳入 1 時，這個測試就會失敗。

第二個測試案例，設定了 mock repository 的 Get() function 在接到 1 跟 2 的傳入值會回傳的結果。這時我們寫的程式傳入 1 或 2 時，這個測試都會成功。

第三個測試案例，設定 mock repository 的 Save() function 會檢查傳入的變數 user 的 Name 欄是否為空字串。


## 搭配 go generate 來產生 mock struct

除了直接執行 mockgen 指令外，我們還可以搭配 `go generate` 來產生 mock struct 檔案。

`go generate` 是在程式中加入 generate 註解，格式如下:
```go
//go:generate command arg1 arg2
```

接著執行 `go generate` ，就會執行註解的指令來產生檔案

我們來寫 go generate 的指令，這時就要用 mockgen 的 Reflect mode 格式
```bash
mockgen [options] <import path> <interface 1>[,<interface 2>]
```
- options: 放額外的參數，至少會寫上 `-destination` 指令產生檔案的位置
- import path: 要寫 go 的 import path，在 `go generate` 裡我們可以用 `.` 就好
- interface: 就是我就想要產生 mock struct 的 interface，有多個時可以用 `,` 串起來


改寫好的 `UserRepository` 如下:

```go
// UserRepository is an interface for user repository.
//
//go:generate mockgen -destination=../mock/user.go . UserRepository
type UserRepository interface {
	Get(id int) (User, error)
	Save(user User) error
}
```

接著執行指令:

```bash
go generate -v ./...
```
我們就可以看到指令把所有的程式檢查過，並成功產生檔案了。


有了這個方法，不管之後有多少的 mock struct 要產生，我們都只要執行 `go generate` 就可以了。

## Reference

- https://github.com/uber-go/mock
- https://puremonkey2010.blogspot.com/2020/12/golang-mock-gomock.html
- https://go.dev/blog/generate