# TreasureHunter

このCUIユーティリティは、"Treasure Data command line tool"をラップしています。

Gitリポジトリで管理されたhiveクエリ一覧から、クエリを選択して実行(td query)を行うことができます。

また、プレースホルダー置換による動的なクエリ実行もサポートします。

## インストール

アプリケーションのGemfileに以下を追記します。

```ruby
gem 'treasure_hunter'
```

そして`bundle`コマンドでインストールします。

```console
$ bundle
```

または、`gem`コマンドでインストールすることもできます。

```console
$ gem install treasure_hunter
```

## 利用方法

### クエリファイル

以下の形式のクエリファイルを作成してGitリポジトリ管理にします。

```yaml
name: クエリの名前を記述します（*必須）
description: クエリの説明を記述します（任意）
database: クエリを発行するデータベースを記述します（*必須）
query: 発行するクエリを記述します。プレースホルダーとして"?"を利用できます（*必須）
```

### 初期設定

`~/.th/th.conf`を作成し、クエリファイルのリポジトリを指定します

```yaml
repository: git@github.com:my-repository/query.git
```

### クエリファイルの取り込み

```console
$ th init
```

### クエリファイルの選択と実行

```console
$th list
query/xxx/xxx # xxx_query_name
query/yyy/yyy # yyy_query_name
```
```console
$ th query query/xxx/xxx arg1 arg2
```

