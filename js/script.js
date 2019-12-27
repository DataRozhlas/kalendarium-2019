import "./byeie"; // loučíme se s IE
import { h, render } from "preact";
/** @jsx h */
import data from "./data";
import { getDateText } from "./datehelper";

const Title = ({ link, classname, text }) => (
  <h3 className={classname}>
    {(link === "")
      ? text
      : <a href={link}>{text}</a>}
  </h3>
);

const LinkImg = ({ classname, link, src }) => (
  <a href={link}>
    <img className={classname} src={src} alt="" />
  </a>
);

const Img = ({ classname, src }) => (
  <img className={classname} src={src} alt="" />
);

const WikiDiv = ({ week }) => (
  <div className="wikidiv" id={`wiki${week[0]}`}>
    <div className="wikiheader">
      <h5 className="wikilead">Nejčtenější na Wikipedii</h5>
      <Title
        link={`http://cs.wikipedia.org/wiki/${week[1].wiki.title.replace(/ /g, "_")}`}
        classname="wikititle"
        text={week[1].wiki.title}
      />
    </div>
    <Img
      classname="wikiimg"
      src={`https://data.irozhlas.cz/kalendarium-2019/img/wiki/${week[0]}.png`}
    />
  </div>
);

const IrDiv = ({ week }) => (
  <div className="irdiv" id={`ir${week[0]}`}>
    <div className="irheader">
      <h5 className="irlead">Nejčtenější na iROZHLAS.cz</h5>
      <Title
        link={week[1].ir.url}
        classname="irtitle"
        text={week[1].ir.title}
      />
    </div>
    <LinkImg
      link={week[1].ir.url}
      classname="irimg"
      src={week[1].ir.img}
    />
  </div>
);

const GoogleDiv = ({ week }) => (
  <div className="googlediv" id={`google${week[0]}`}>
    <div className="googleheader">
      <h5 className="googlelead">Našli jste přes Google</h5>
      <Title
        link=""
        classname="googletitle"
        text={week[1].google.title}
      />
    </div>
    <Img
      classname="googleimg"
      src={`https://data.irozhlas.cz/kalendarium-2019/img/wordcloud/${week[0]}.png`}
    />
  </div>
);

const WeekTitle = ({ week }) => {
  const weekNumber = week[0].replace("week", "");
  return (
    <h2 className="weektitle">
      {`${weekNumber}. týden (${getDateText(weekNumber)})`}
    </h2>
  );
};

const WeekText = ({ text }) => (
  // eslint-disable-next-line react/no-danger
  <div className="weektext" dangerouslySetInnerHTML={{ __html: text }} />
);

const WeekDiv = ({ week }) => (
  <div className="weekdiv" id={week[0]}>
    <GoogleDiv week={week} />
    <IrDiv week={week} />
    <WikiDiv week={week} />
  </div>
);

const Calendar = () => (
  <div>
    {Object.entries(data).map(week => (
      <div>
        <div className="separator" id={`sep${week[0]}`}>• • •</div>
        <WeekTitle week={week} />
        <WeekText
          text={week[1].text}
        />
        <WeekDiv week={week} />
      </div>
    ))}
  </div>
);

// ========================================

render(<Calendar />, document.getElementById("kalendarium"));
