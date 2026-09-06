FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        latexmk \
        texlive-latex-extra \
        texlive-lang-other \
        texlive-xetex \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

ENTRYPOINT ["latexmk"]
CMD ["-xelatex", "-interaction=nonstopmode", "-halt-on-error", "main.tex"]
