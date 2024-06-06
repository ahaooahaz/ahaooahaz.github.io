---
author: ahaooahaz
image:
urlname: "smart-pointer"
slug: "smart-pointer"
date: 2024-06-06T17:09:59+08:00
title: "智能指针"
tags: []
draft: true
---
<!--more-->

智能指针依赖C++自行调用析构函数的特点，使用对象的生命周期来自动管理在堆空间申请的内存。
## auto_ptr
auto_ptr在C++98中就存在，本身存在明显的问题。
### 所有权转义
当auto_ptr进行相互赋值操作之后，会进行所有权转移，老的指针会被设置为空指针，后续只能使用新的指针进行解引用等操作。
```cpp
#include <memory>
using namespace std;
int main() {
	auto_ptr<int> p1(new int);
	auto_ptr<int> p2 = p1;
	*p1 = 1; // 此时对象的操作权限已经转移到p2上，p1被置空。
	return 0;
}
```
导致以下问题：
- 不能结合STL容器使用
### 不适用于管理数组
auto_ptr在析构时使用的方法为`delete`，而当析构数组时，需要使用`delete[]`，所以不能用auto_ptr管理数组指针。
```cpp
#include <memory>
using namespace std;
int main() {
	int n = 100000;
	while (n--) {
		auto_ptr<int> p1(new int[10000]);
	} // 产生内存泄漏
	return 0;
}
```
## unique_ptr
unique_ptr出现于C++11，不支持拷贝和赋值操作，只能通过右值引用的方式转移资源的所有权。默认情况下于`auto_ptr`一样使用`delete`来析构资源，但也可以通过自定义删除器来实现对资源的析构操作，支持lambda表达式实现自定义删除器，同时支持了对数组资源的管理。
### 删除拷贝构造和赋值操作
```cpp
#include <mempry>
using namespace std;
int main() {
	unique_ptr<int> p1(new int(32));
	// unique_ptr<int> p2(p1); 拷贝构造函数产生编译报错
	// unique_ptr<int> p2 = p1; 赋值操作产生编译报错
	unique_ptr<int> p2(std::move(p1)); // 将p1转义为右值即可以调用移动构造函数
	unique_ptr<int> p3 = std::move(p2); // 同样可以实现资源的所有权转移
	return 0;
}
```
### 支持管理数组
```cpp
#include <memory>
using namespace std;
int main() {
	unique_ptr<int[]> p(new int[100]);
	return 0;
}
```
### 自定义删除器
```cpp
#include <memory>
#include <iostream>
using namespace std;
class A {};
class ADeleter1 {
public:
	void operator()(A* p) {
		cout << "deleted p 1" << endl;
	}
};

void ADeleter2(A* p) {
	cout << "deleted p 2" << endl;
}
int main() {
	unique_ptr<A, ADeleter1> p(new A);
	unique_ptr<A, decltype(ADeleter2)*> p(new A, ADeleter2);
	return 0;
}

```
## shared_ptr
shared_ptr出现于C++11，采用引用计数的方法，解决了`auto_ptr`和`unique_ptr`存在的问题，同时也支持指定删除器。但`shared_ptr`也存在自己的问题。
### 循环引用
```cpp
#include <memory>
#include <iostream>
using namespace std;
class A {
public:
	shared_ptr<B> b;
	~A() {
		cout << "delete A" << endl;
	}
};
class B {
public:
	shared_ptr<A> a;
	~B() {
		cout << "delete B" << endl;
	}
}
int main() {
	shared_ptr<A> pa(new A);
	shared_ptr<B> pb(new B);
	pa->b = pb;
	pb->a = pa;
	return 0;
}
```
当两个类互相持有对方的`shared_ptr`并相互指向时，引用计数会被置为2，当生命周期到达时，会使拥有的`shared_ptr`计数为1，所以并没有执行对应的析构函数，导致内存泄漏。
## weak_ptr
weak_ptr出现于C++11，用来解决`shared_ptr`的循环引用问题，只能使用`weak_ptr`或者`shared_ptr`构造，`weak_ptr`的赋值操作不会使`shared_ptr`的引用计数变化。`weak_ptr`不能对指针进行解引用操作，类似只读的操作，但可以通过`lock`方法拷贝一个`shared_ptr`进行操作，当资源已经被析构时，调用`lock`方法会返回一个空的`shared_ptr`。