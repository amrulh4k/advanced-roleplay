## Como instalar o Sampctl?

1. Abra o seu terminal (powershell, cmdline, bash, etc)
2. Digite `set-executionpolicy remotesigned -scope currentuser` para dar permiss�es para a instala��o de pacotes

- Caso você use o **chocolatey** s� instalar pelo comando `choco`
1. Instale o **Scoop** digitando `iex (new-object net.webclient).downloadstring('https://get.scoop.sh')`
2. Adicione o **SampCTL** ao Scoop digitando `scoop bucket add southclaws https://github.com/Southclaws/scoops.git`;
3. Instale o **SampCTL** `scoop install sampctl`

## Como utilizar o Sampctl? (little guide by: Dobby)


- `sampctl p init` - Inicia o sampctl e faz o setup do pawn.json/yml.
- `sampctl p install <username:version>` - Instala um pacote, ex: sampctl p install pawn-lang/samp-stdlib
- `sampctl p uninstall <package name>` - Desinstala um pacote
- `sampctl p build` - Builda o nosso Gamemode
- `sampctl p run` - Faz o gamemode iniciar
- `sampctl p run --container` - (Possibilidade) Roda o gamemode num container, podendo ser Docker, AWS, etc
- `sampctl p ensure` - Faz o download de todos os pacotes marcados como dependência em pawn.json.
- `sampctl p autocomplete` - Gera um arquivo de autocomplete para o seu terminal. 


Você pode adicionar --help em qualquer comando para um guia sobre o comando. Caso queira ajuda para o pr�prio sampctl, digite `sampctl --help`.


E n�o se preocupe quanto ao sistema operacional, o sampctl pega os pacotes baseado no sistema operacional em qual você tá rodando - ou seja, se você tá em Linux, ele vai pegar os binários para Linux. Mesma coisa com Windows. Você também pode fazer isso automaticamente, pelo comando, s� digitar `sampctl p ensure --platform linux/windows`


It gets the packages based on your operating system. So if your servers on Linux, it'll grab the Linux binaries. Same with Windows. You can automatically do this via sampctl p ensure --platform linux.

Caso queira saber mais sobre o Sampctl, acesse o [reposit�rio deles](https://github.com/Southclaws/sampctl).
