# notice_scraper

충남대 기초프로젝트랩 긴급구조 팀의 프로젝트입니다.\
여러 웹상의 공지를 모아 앱에 통합하여 띄우는 기능을 수행합니다. 

# 내부 구현 설명

## Scraper


Scraper는 공지를 얻어오는 고수준의 추상 클래스입니다.
공지를 얻으려면 Scraper 클래스의 scrap() 메서드를 실행하시면 됩니다.

현재 구현된 Scraper의 세부 클래스는 다음과 같습니다.

### CNUCyberCampusScraper

충남대 사캠 공지를 불러오는 Scraper입니다. 생성자에서 충남대 사캠의 아이디와 비밀번호를 받습니다. 공지를 얻기 위해 다음과 같은 예시 코드를 작성할 수 있습니다.

```dart
// 예시 1
List<Notice> notices = await CNUCyberCampusScraper('아이디', '비밀번호').scrap();

// 예시 2
Scraper scraper = CNUCyberCampusScraper('아이디', '비밀번호');
List<Notice> notices = await scraper.scrap();
```

## NoticeManager (아직 테스트 해보지 않아서 작동 안될 확률 높음)

등록된 Scraper를 가지고 공지를 총괄하는 클래스입니다. Singleton 패턴으로 구현되어있으며, 보통의 경우 Scraper를 직접 호출하는 대신 여기서 공지를 얻어오게 됩니다. 공지는 사이트별로 가져올 수 있습니다.

또한 Origin마다 가장 최근에 scrap된 공지의 날짜/시간도 알 수 있습니다. 이는 추후에 공지가 scrap되었을 때 알람을 주기 위해서 scrap된 공지가 원래 있던 공지인지, 아니면 새로 들어온 공지인지 알아내는데 쓰입니다. 

```dart
// 현재 등록된 사이트들을 가져온다. Origin은 사이트 정보를 담고 있는 클래스이다.
List<Origin> origins = NoticeManager().origins;

// 리스트의 사이트 중 첫번째 사이트의 공지 목록을 불러온다.
List<Notice> notices = await NoticeManager().scrap(origins.first);

// 리스트의 사이트 중 첫번째 사이트에서 scrap된 가장 최근의 공지의 날짜/시간을 가져온다.
DateTime latest = await NoticeManager().getLastUploadedAt(origins.first);
```

# 예상 기능 목록

현재 구현할 것으로 예상되는 기능의 목록이며, 프로토타입때는 전부 구현하지 않아도 될 것으로 생각된다.

현재 예상 기능 목록
- 외부 스크랩 스크립트를 불러와서 스크랩하는 Scraper를 구현하여 애드온 형식으로 여러 공지 사이트에서 공지를 얻을 수 있게 하는 기능
- ~~앱에서 공지를 관리하는 전역 저장소를 구현하여, Scraper를 직접적으로 호출하지 않고, 저장소에서 Scraper를 이용해 저장소를 업데이트하는 느낌으로 공지를 관리하는 기능~~ -> 구현 완료
- 로그인이 필요하던가 하는 등의 private한 공지 정보를 보호하기 위해 앱 자체에 로그인 기능을 넣고, 해당 비밀번호로 공지 정보를 암호화하는 기능.
    - 불러온 공지 뿐만 아니라, 해당 공지를 불러오기 위해 사용된 아이디, 비밀번호 등도 암호화해야함.
- UI 부분은 Scraper를 직접 호출하지 않고, 그냥 저장소에서 공지를 불러오는 방식으로 공지를 가져오게 만들기
- 앱이 종료되었을 때 백그라운드에서 스크랩을 수행하여 주기적으로 저장소의 공지를 업데이트하는 기능